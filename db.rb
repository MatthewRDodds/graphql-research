require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  dbfile: ":memory:",
  database: ':memory:'
)

ActiveRecord::Schema.define do
  create_table :books do |t|
    t.string :title
    t.integer :page_count
    t.integer :author_id
  end

  create_table :authors do |t|
    t.string :first_name
    t.string :last_name
  end
end

class Book < ActiveRecord::Base
  belongs_to :author
end

class Author < ActiveRecord::Base
  has_many :books
end

a1 = Author.create(first_name: 'Henry', last_name: 'Maddow')
a2 = Author.create(first_name: 'Emily', last_name: 'Johnson')

Book.create(title: 'Batman', page_count: 100, author: a1)
Book.create(title: 'Economics 101', page_count: 315, author: a1)
Book.create(title: 'Space Stuff', page_count: 100, author: a1)

Book.create(title: 'Youtubing', page_count: 417, author: a2)
Book.create(title: 'Ant Hunting', page_count: 789, author: a2)
Book.create(title: 'Philosophy of success', page_count: 19, author: a2)
