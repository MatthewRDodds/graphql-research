require 'bundler'
require 'pry'
require 'awesome_print'
require 'graphql'

Bundler.setup

require_relative './db.rb'

BookType = GraphQL::ObjectType.define do
  name "Book"
  description "A book"

  field :id, !types.ID
  field :title, !types.String
  field :page_count, !types.Int
  field :author_id, !types.String
end

BookQueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :book do
    type BookType
    argument :id, !types.ID
    resolve -> (obj, args, ctx) { Book.find(args["id"]) }
  end
end

BookTitleQueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :book do
    type BookType
    argument :title, !types.String
    resolve -> (obj, args, ctx) { Book.find_by(title: args[:title]) }
  end
end

BookAuthorQueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :book do
    type BookType
    argument :author_id, !types.ID
    resolve -> (obj, args, ctx) { Book.where(author_id: args[:author_id]) }
  end
end

Schema = GraphQL::Schema.new(query: BookQueryType, max_depth: 8)

query_by_id = '{ book(id: "1") { title, page_count, author_id } }'
puts "Result for #{query_by_id}"
ap Schema.execute(query_by_id)
puts

TitleSchema = GraphQL::Schema.new(query: BookTitleQueryType, max_depth: 8)

query_for_title = '{ book(title: "Batman") { title, page_count, author_id } }'
puts "Result for #{query_for_title}"
ap TitleSchema.execute(query_for_title)
puts

AuthorSchema = GraphQL::Schema.new(query: BookAuthorQueryType, max_depth: 8)

# Have not figured this out yet. It tries to call title on the AR::Relation
# query_for_author = '{ book(author_id: "2") { title } }'
# puts "Result for #{query_for_author}"
# ap AuthorSchema.execute(query_for_author, debug: true)
# puts


