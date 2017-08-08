module RecordModelHelper
  def self.new_record(options)
    hash = {
      entity_id: options[:entity_id],
      record_id: options[:record_id],
      content: options[:content]
    }.with_indifferent_access

    record = Record.new(hash)
  end
end