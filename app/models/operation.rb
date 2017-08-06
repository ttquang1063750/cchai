class Operation < ApplicationRecord
  STAGE_OPTIONS = %w(init join log)
  belongs_to :page

  [:stage, :query, :name].each do |e|
    validates_presence_of e
  end

  scope :init, -> { where stage: 'init' }
  scope :active, -> { where stage: 'join' }
  scope :log, -> { where stage: 'log' }

  validates :stage, inclusion: {in: STAGE_OPTIONS}
  validates :name, format: {with: SessionVariable::VALID_NAME_REGEX}, uniqueness: {scope: :page_id}

  def insert_data_to_store(store, connect, order_by)
    case stage
    when 'init'
      data = get_data_by_query(connect)
    when 'join'
      data = get_data_by_join_query(connect)
    when 'log'
      data = get_data_by_log_query(connect, order_by)
    end
    store.db[name.to_sym] = data
    store
  end

  def get_data_by_query(connect)
    Octopus.using(connect.database.to_sym) do
      data = []
      new_hash = {}
      hash = Oj.load(self.query).with_indifferent_access
      table_id = hash[:table_id]
      new_hash[:condition]= hash[:condition]
      new_hash[:rules] = []
      hash[:rules].each { |e| new_hash[:rules] << e unless e[:value].empty? }
      if new_hash[:rules].empty?
        rows = Row.where(table_id: table_id)
      else
        arel_query = QueryBuilderParseToArelQuery.new(new_hash, table_id, connect).to_query
        return [] if arel_query.empty?
        rows = Row.find_by_sql(arel_query)
      end
      raws = Raw.where(row_id: rows.map(&:id))
      raws.each { |e| data << Oj.load(e.data).merge({row_id: e.row_id, table_id: e.table_id}) }
      data = [{"table_id": table_id}] if data.empty? && new_hash[:rules].present?
      # data = Page.change_value_csv(Column.where(table_id: table_id), data) if new_hash["rules"].empty?
      data
    end
  end

  def get_data_by_join_query(connect)
    query = JoinQueryVer2.new(Oj.load(self.query), id, connect).to_query
    return [] unless query.present?
    query
  end

  def get_data_by_log_query(connect, order_by)
    new_hash = {}
    hash = Oj.load(self.query).with_indifferent_access
    new_hash[:condition]= hash[:condition]
    new_hash[:rules] = []
    hash[:rules].each { |e| new_hash[:rules] << e unless e[:value].empty? }
    if new_hash[:rules].present?
      query = LogChangementQuery.new(new_hash, connect).to_query
      return [] unless query.present?
      data = LogChangement.using(connect.database.to_sym).where(query)
                                                         .order("#{order_by[:column]} #{order_by[:direction]}")
    else
      data = LogChangement.using(connect.database.to_sym).all
                                                         .order("#{order_by[:column]} #{order_by[:direction]}")
    end
    data
  end

end
