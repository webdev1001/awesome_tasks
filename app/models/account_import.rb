class AccountImport < ActiveRecord::Base
  belongs_to :account

  has_one :uploaded_file, as: :resource, dependent: :destroy
  accepts_nested_attributes_for :uploaded_file

  has_many :account_import_columns, dependent: :destroy

  validates_presence_of :account, :uploaded_file

  state_machine :state, initial: :new do
    event :execute do
      transition :new => :executing
    end

    event :finish do
      transition :executing => :finished
    end
  end

  def self.translated_states
    {
      t(".new") => "new",
      t(".executing") => "executing",
      t(".finished") => "finished"
    }
  end

  def translated_state
    AccountImport.translated_states.each do |key, val|
      return key if state.to_s == val
    end

    raise "Unknown state: #{state}"
  end

  def execute
    count = 0

    rows do |row|
      line = account.account_lines.new

      account_import_columns.each do |account_import_column|
        line.__send__("#{account_import_column.column_type}=", row[account_import_column.column_no])
      end

      line.save!
      count += 1
    end

    return {
      count: count
    }
  end

  def rows
    File.open(uploaded_file.file.path, "r", encoding: "ISO8859-1") do |fp|
      CsvLazy.new(io: fp, debug: false) do |row|
        next if row.empty?
        yield row
      end
    end
  end

  def columns_count
    rows do |row|
      return row.length
    end
  end
end
