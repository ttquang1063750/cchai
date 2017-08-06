class Project < ApplicationRecord
  belongs_to :client

  has_many :role_types, dependent: :destroy
  has_many :users, -> { distinct }, through: :roles
  has_many :pages, dependent: :destroy
  has_many :roles, through: :role_types
  has_many :tasks, dependent: :destroy
  has_many :tables, dependent: :destroy
  has_many :session_variables, dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :batch_processes, dependent: :destroy
  has_many :log_changement
  has_one :db_connect, dependent: :destroy


  extend FriendlyId

  friendly_id :short_name, use: :slugged

  %i(name short_name patitent_num period_start_date period_end_date).each do |e|
    validates_presence_of e
  end
  validates :name, uniqueness: {case_sensitive: false}
  validates :short_name, uniqueness: {case_sensitive: false}
  scope :desc, -> { order(updated_at: :desc) }
  scoped_search on: %i(name short_name)

  def clone(options, connect)
    project_dup = self.dup
    Project.transaction do
      project_dup.assign_attributes(options)
      raise ActiveRecord::Rollback unless project_dup.valid?
      project_dup.save

      # Roles and RoleTypes Dup
      roles_by_role_types = self.role_types.map(&:roles)
      role_types_dup = self.role_types.map(&:dup)
      role_types_dup.each { |e| e.project_id = project_dup.id }
      RoleType.transaction do
        role_types_dup.each(&:save)
        Role.transaction do
          role_types_dup.each.with_index do |role_type, index|
            if roles_by_role_types[index].present?
              roles_dup = roles_by_role_types[index].map(&:dup)
              roles_dup.each { |e| e.role_type_id = role_type.id }
              roles_dup.each(&:save)
            end
          end
        end
      end

      #Copy_image from image_folder to the new one
      images_dup = self.pictures.map(&:dup)
      Picture.transaction do
        self.pictures.each_with_index { |o, i| images_dup[i].duplicate_image_data(o, project_dup.id) }
      end

      # Pages, Operations And LocalVariables Dup
      operations_by_pages_dup = self.pages.map(&:operations)
      local_variables_by_pages_dup = self.pages.map(&:local_variables)
      pages_dup = self.pages.map(&:dup)
      pages_dup.each { |e| e.project_id = project_dup.id }
      Page.transaction do
        pages_dup.each do |page|
          layout = Project.display_privacy(page, role_types_dup)
          page.layout = Oj.dump(layout)
        end
        pages_dup.each(&:save)
        Operation.transaction do
          pages_dup.each.with_index do |page, index|
            unless operations_by_pages_dup[index].empty?
              operations_dup = operations_by_pages_dup[index].map(&:dup)
              operations_dup.each { |e| e.page_id = page.id }
              # operations_dup.each do |e|
              #   # Update new column_id in query
              #   query = Oj.load(e.query).with_indifferent_access
              #   query[:rules].count.times do |i|
              #     column_id = query[:rules][i][:id]
              #     table_name_ori =  find_table_name_by_column_id(column_id)
              #     column_name_ori = find_column_name(column_id)
              #     columns_dup_by_tables_dup = tables_dup.map(&:columns)
              #     tables_dup.each.with_index do |table, index|
              #       columns_dup_by_tables_dup[index].each do |column|
              #         table_name_dup = find_table_name(column.table_id)
              #         query[:rules][i].store(:id, column.id.to_s) if column.name == column_name_ori && table_name_dup == table_name_ori
              #       end
              #     end
              #     e.query = query.to_json
              #   end
              # end
              operations_dup.each(&:save)
            end
          end
        end
        LocalVariable.transaction do
          pages_dup.each.with_index do |page, index|
            unless local_variables_by_pages_dup[index].empty?
              local_variables_dup = local_variables_by_pages_dup[index].map(&:dup)
              local_variables_dup.each { |e| e.page_id = page.id }
              local_variables_dup.each(&:save)
            end
          end
        end
      end

      # Session_variables dup
      session_variables_dup = self.session_variables.map(&:dup)
      session_variables_dup.each { |e| e.project_id = project_dup.id }
      SessionVariable.transaction do
        session_variables_dup.each(&:save)
      end

      #Tables And Columns dup
      if connect.present?
        columns_by_tables_dup = Table.using(self.db_connect.database.to_sym).where(project_id: self.id).map(&:columns)
        tables_dup = Table.using(self.db_connect.database.to_sym).where(project_id: self.id).map(&:dup)
        tables_dup.each { |e| e.project_id = project_dup.id }
        DbConnect.transaction do
          connect[:project_id] = project_dup.id
          db_connect_exist = DbConnect.find_by(
                                               host: connect[:host], database: connect[:database],
                                               port: connect[:port], username: connect[:username]
                                              )
          unless db_connect_exist.present?
            db_connect = DbConnect.new(connect)
            db_connect.save
            Shard_Connect.connect_to_shard
            begin
              sql_execute(db_connect.database)
              Octopus.using(db_connect.database.to_sym) do
                Table.transaction do
                  tables_dup.each { |e| Table.create name: e.name, project_id: e.project_id }
                  Table.all.each { |table| @table_count_id = table.id if table.name == 'table_count' }
                  Column.transaction do
                    Table.all.each.with_index do |table, index|
                      if columns_by_tables_dup[index].present?
                        columns_dup = columns_by_tables_dup[index].map(&:dup)
                        columns_dup.each { |e| e.table_id = table.id }
                        columns_dup.each { |e| Column.create name: e.name, content_type: e.content_type, condition: e.condition, table_id: e.table_id }
                        #Clone cell for table_count
                        Column.all.each do |column|
                          if column.table_id == @table_count_id
                            @column_table_name_id = column.id if column.name == 'table_name'
                            @column_count_value_id = column.id if column.name == 'count_value'
                          end
                        end
                      end
                      unless table.name == 'table_count'
                        Row.transaction do
                          row = Row.create! unique_id: SecureRandom.uuid, table_id: @table_count_id
                          Cell.transaction do
                            Cell.create! column_id: @column_table_name_id, row_id: row.id, value: table.name
                            Cell.create! column_id: @column_count_value_id, row_id: row.id, value: 0
                            Raw.transaction do
                              data = Oj.dump(Cell.get_cells_value(Cell.where(row_id: row.id)))
                              Raw.create! data: data, table_id: table.id, row_id: row.id
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            rescue => exc
              project_dup = nil
              @error = exc.message
            end
          else
            project_dup = nil
            @error = 'Database was exist connected'
          end
        end
      end
      raise ActiveRecord::Rollback if project_dup.nil?
    end
    project_dup.nil? ? project = {project_dup: project_dup, error: @error} : project = {project_dup: project_dup}
  end

  def self.changement_update(params, cell, value, connect)
    column_name = Column.using(connect.database.to_sym).find(cell.column_id).name
    bf_item = cell.value
    af_item = value
    LogChangement.using(connect.database.to_sym)
                 .create(
                  user_email: params[:client], role_type: params[:role_name], 
                  page_name: params[:page_name], column_name: column_name, 
                  bf_item: bf_item, af_item: af_item, action: 'update'
                )
  end

  def self.changement_create(params, column, value, connect)
    column_name = Column.using(connect.database.to_sym).find(column.id).name
    bf_item= ''
    af_item = value
    LogChangement.using(connect.database.to_sym)
                 .create(
                  user_email: params[:client], role_type: params[:role_name], 
                  page_name: params[:page_name], column_name: column_name, 
                  bf_item: bf_item, af_item: af_item, action: 'create'
                )
  end

  def self.changement_delete(raws, connect, info)
    af_item = ''
    Oj.load(raws.data).to_a.each do |e|
      LogChangement.using(connect.database.to_sym)
                   .create(
                    user_email: info[:email], role_type: info[:role_type],
                    page_name: info[:page_name], column_name: e[0], bf_item: e[1],
                    af_item: af_item, action: 'delete'
                  )
    end
  end

  private

  def self.display_privacy(page, role_types_dup)
    @input_hash = Oj.load(page.layout).with_indifferent_access
    @child_tag = 'children'
    @filter_tag = 'privacy'
    Project.filter(@input_hash, role_types_dup)
  end

  def self.filter(hash, role_types_dup)
    hash.each do |k, v|
      if k == @filter_tag && v.is_a?(Array) && !v.empty?
        @new_role_ids =[]
        v.each do |role_id|
          find_role = RoleType.find(role_id).name
          role_types_dup.each { |role| @new_role_ids << role.id.to_s if role.name == find_role }
        end
        hash[k] = @new_role_ids
        return hash
      elsif k == @child_tag && v.is_a?(Array) && !v.empty?
        tmp = []
        v.each do |e|
          tmp_filter = filter(e, role_types_dup)
          tmp.push(tmp_filter) unless tmp_filter.nil?
        end
        hash[@child_tag] = tmp
      end
    end
    hash
  end

  def sql_execute(shard_name)
    path = Rails.root.join('db/clone.sql').to_s
    # Split divides str into substrings based on a delimiter, returning an array of these substrings
    sql = File.read(path).split(/;/)
    sql = Oj.load(sql.to_s % {:schema => shard_name})
    sql.each { |query| ActiveRecord::Base.using(shard_name.to_sym).connection.execute query if query.present? }
  end

  def should_generate_new_friendly_id?
    short_name_changed?
  end
end