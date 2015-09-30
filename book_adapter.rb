require './virtual_book_proxy'

class BookAdapter
  attr_accessor :book_proxy

  def initialize(pool_size = 1)
    @book_proxy = VirtualBookProxy.new(pool_size)
  end

  def books
    return books_list if loaded_books_list? && up_to_date?

    @book_store_connection = @book_proxy.connect
    books_list.concat @book_store_connection.books
  end

  def show_book(id)
    puts "Show book id: #{id}"
    if !books.include?(id)
      puts "#{id} isn't exist"
    else
      if @book_store_connection.nil?
        connection = @book_proxy.connect
        puts connection.show(id)
      else
        puts "Connected..."
        puts @book_store_connection.show(id)
      end
    end
    # You can look at the code in book_store_connection.rb
    # Here is some requirements
    #  - if book isn't exist, show the error
    #  - actually connect to book_store, using the virtual_book_proxy
    #  - save the data, if user connect again, just show the data inside the adapter
    #  GOOD LUCK!!!
  end

  protected

  def loaded_books_list?
    books_list.size > 0
  end

  def books_list
    @books_list ||= []
  end

  def up_to_date?
    true
  end
end

puts 'Start'

book_adapter = BookAdapter.new(2)
p 'Book ids: ', book_adapter.books
book_adapter.show_book(1)
#p 'Book ids: ', book_adapter.books
#p 'Book ids: ', book_adapter.books
#p 'Book ids: ', book_adapter.books
#p 'Book ids: ', book_adapter.books
