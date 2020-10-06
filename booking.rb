class Booking

  attr_accessor :plantinium_seats, :glod_seats, :silver_seats

  NUMBER_OF_SHOW = 3

  def initialize
    @plantinium_seats= []
    @glod_seats= []
    @silver_seats = []
    1.upto(NUMBER_OF_SHOW) do |index|
      @plantinium_seats[index] = {"320" => %w(A1 A2 A3 A4 A5 A6 A7 A8 A9)}
      @glod_seats[index] = {"280" => %w(B1 B2 B3 B4 B5 B6)}
      @silver_seats[index] = {"240" => %w(C2 C3 C4 C5 C6 C7)}
    end
  end

  def book_now
    print_message
    show_no = take_show_input
    if check_avaliality(show_no)
      seat_no = take_seat_input(show_no)
    end
    book_seat(show_no, seat_no)
    print_message
  end

  def print_message
    1.upto(NUMBER_OF_SHOW) do |show|
      puts "Show #{show} Running in Audi #{show}"
      puts "#{plantinium_seats[show].values.flatten!.join(',')}"
      puts "#{glod_seats[show].values.flatten!.join(',')}"
      puts "#{silver_seats[show].values.flatten!.join(',')}"
    end
  end

  def take_show_input
    puts "Please enter Show Number"
    show_no = gets.chomp.to_i
    if show_no >=1 && show_no <=3
      show_no
    else
      puts "Invalid Input, There are only 3 Shows Running, Please Enter value between 1 to 3"
      take_show_input
    end
  end

  def check_avaliality(show_no)
    unless plantinium_seats[show_no].empty? && glod_seats[show_no].empty? && silver_seats[show_no].empty?
      puts "Avaliable Seats Are"
      puts "#{plantinium_seats[show_no].values.flatten!.join(',')}"
      puts "#{glod_seats[show_no].values.flatten!.join(',')}"
      puts "#{silver_seats[show_no].values.flatten!.join(',')}"
      true
    end
  end

  def take_seat_input(show_no)
    puts "Please Enter Seat No"
    seat_nos = gets.chomp.split(',')
    seat_nos
  end

  def book_seat(show_no, seat_nos)
    seat_nos.each do |seat_no|
      if is_platinium?(show_no, seat_no)
        platinium_sheet_cost = plantinium_seats[show_no].keys[0]
        plantinium_seats_left_sheets = plantinium_seats[show_no].values.flatten! - [seat_no]
        plantinium_seats[show_no][platinium_sheet_cost] = plantinium_seats_left_sheets
      elsif is_gold?(seat_no)

      elsif is_silver?(seat_no)

      end
    end
  end

  def is_platinium?(show_no, seat_no)
    plantinium_seats[show_no].values.flatten!.include?(seat_no)
  end

  def is_gold?(seat_no)
    glod_seats.include?(seat_no)
  end

  def is_silver?(seat_no)
    silver_seats.include?(seat_no)
  end

end

booking = Booking.new.book_now