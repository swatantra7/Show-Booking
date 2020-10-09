class Booking

  attr_accessor :plantinium_seats, :gold_seats, :silver_seats

  NUMBER_OF_SHOW = 3

  def initialize
    @plantinium_seats= []
    @gold_seats= []
    @silver_seats = []
    1.upto(NUMBER_OF_SHOW) do |index|
      @plantinium_seats[index] = {"320" => platinum_seats_arr[index]}
      @gold_seats[index] = {"280" => gold_seats_arr[index]}
      @silver_seats[index] = {"240" => silver_seats_arr[index]}
    end
  end

  def platinum_seats_arr
    {1 => %w(A1 A2 A3 A4 A5 A6 A7 A8 A9), 2 => %w(A1 A2 A3 A4 A5 A6 A7), 3 => %w(A1 A2 A3 A4 A5)}
  end

  def gold_seats_arr
    {1 => %w(B1 B2 B3 B4 B5 B6), 2 => %w(B2 B3 B4 B5 B6), 3 => %w(B1 B2 B3 B4 B5 B6 B7 B8)}
  end

  def silver_seats_arr
    {1 => %w(C2 C3 C4 C5 C6 C7), 2 => %w(C1 C2 C3 C4 C5 C6 C7), 3 => %w(C1 C2 C3 C4 C5 C6 C7 C8 C9)}
  end

  def book_now
    print_message
    puts instructions
    show_no = take_show_input
    if check_avaliality(show_no)
      seat_no = take_seat_input(show_no)
    end
    ps, gs, bss = book_seat(show_no, seat_no)
    total_amount = calculate_booking_cost(ps, gs, bss)
    print_slip(ps, gs, bss, total_amount)
    print_message
  end

  def print_message
    puts "Seating arrangement:"
    puts "========================================="
    1.upto(NUMBER_OF_SHOW) do |show|
      puts "Show #{show} Running in Audi #{show}"
      puts "#{plantinium_seats[show].values.flatten!.join(',')}"
      puts "#{gold_seats[show].values.flatten!.join(',')}"
      puts "#{silver_seats[show].values.flatten!.join(',')}"
      puts
    end
    puts "====================================================="
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

  def print_slip(ps, gs, bss, total_amount)
    puts "*********************************************************"
    puts "charged Cost For Booking #{total_amount.round(2)}"
    puts ""
    puts "Revenue: Rs #{revenue_generated(ps, gs, bss).round(2)}"
    puts
    puts "Service Tax Rs:#{service_taxes(ps, gs, bss).round(2)}"
    puts
    puts "Swachh Bharat Cess:#{swachh_bharat_cess_taxes(ps,gs, bss).round(2)}"
    puts
    puts "Krishi Kalyan Cess: #{krishi_kalyan_tax_percentage(ps, gs, bss).round(2)}"
    puts
    puts "*********************************************************"
  end

  def revenue_generated(ps, gs, bss)
    [ps, gs, bss].map{|sale_detail| sale_detail.keys.first * sale_detail.values.first}.sum
  end

  def service_taxes(ps,gs, bss)
    [ps, gs, bss].map{|sale_detail| sale_detail.values.first * (sale_detail.keys.first* service_tax_percentage/100)}.sum
  end

  def swachh_bharat_cess_taxes(ps, gs, bss)
    [ps, gs, bss].map{|sale_detail| sale_detail.values.first * (sale_detail.keys.first* swachh_bharat_cess/100)}.sum
  end

  def krishi_kalyan_tax_percentage(ps, gs, bss)
    [ps, gs, bss].map{|sale_detail| sale_detail.values.first * (sale_detail.keys.first* krishi_kalyan_percentage/100)}.sum
  end

  def calculate_booking_cost(ps, gs, bss)
    total_amount = 0
    if ps.values.first.zero? && gs.values.first.zero? && bss.values.first.zero?
      puts "Opps!!, Invalid Seats, Please Try Again"
      puts "+++++++++++++++++++++++++++++++++++++++++++"
      book_now
    else
      total_amount = [ps, gs,bss].map{|seat_detail| seat_detail.values.first*seat_detail.keys.first+ seat_detail.values.first*(seat_detail.keys.first*service_tax_percentage/100) + seat_detail.values.first*(seat_detail.keys.first*krishi_kalyan_percentage/100) + seat_detail.values.first*(seat_detail.keys.first*swachh_bharat_cess/100)}.sum
    end
    total_amount
  end

  def check_avaliality(show_no)
    unless plantinium_seats[show_no].empty? && gold_seats[show_no].empty? && silver_seats[show_no].empty?
      puts "Avaliable Seats Are"
      puts "#{plantinium_seats[show_no].values.flatten!.join(',')}"
      puts "#{gold_seats[show_no].values.flatten!.join(',')}"
      puts "#{silver_seats[show_no].values.flatten!.join(',')}"
      true
    end
  end

  def take_seat_input(show_no)
    puts "Please Enter Seat No"
    seat_nos = gets.chomp.split(',').map(&:strip)
    seat_nos
  end

  def book_seat(show_no, seat_nos)
    booked_platinium_sheet = 0
    booked_gold_sheet = 0
    booked_silver_sheet = 0
    seat_nos.each do |seat_no|
      if is_platinium?(show_no, seat_no)
        platinium_sheet_cost = plantinium_seats[show_no].keys[0]
        plantinium_seats_left_sheets = plantinium_seats[show_no].values.flatten! - [seat_no]
        plantinium_seats[show_no][platinium_sheet_cost] = plantinium_seats_left_sheets
        booked_platinium_sheet += 1
      elsif is_gold?(show_no, seat_no)
        gold_sheet_cost = gold_seats[show_no].keys[0]
        gold_sheet_cost_left_sheets = gold_seats[show_no].values.flatten! - [seat_no]
        gold_seats[show_no][gold_sheet_cost] = gold_sheet_cost_left_sheets
        booked_gold_sheet += 1
      elsif is_silver?(show_no, seat_no)
        silver_sheet_cost = silver_seats[show_no].keys[0]
        silver_sheet_cost_left_sheets = silver_seats[show_no].values.flatten! - [seat_no]
        silver_seats[show_no][silver_sheet_cost] = silver_sheet_cost_left_sheets
        booked_silver_sheet += 1
      end
    end
    [{320 => booked_platinium_sheet}, {280 => booked_gold_sheet}, {240 => booked_silver_sheet}]
  end

  def is_platinium?(show_no, seat_no)
    plantinium_seats[show_no].values.flatten!.include?(seat_no)
  end

  def is_gold?(show_no, seat_no)
    gold_seats[show_no].values.flatten!.include?(seat_no)
  end

  def is_silver?(show_no, seat_no)
    silver_seats[show_no].values.flatten!.include?(seat_no)
  end

  def service_tax_percentage
    14
  end

  def krishi_kalyan_percentage
    0.5
  end

  def swachh_bharat_cess
    0.5
  end

  def instructions
    <<-instruction
      1. A, B & C rows are categorised into Platinum, Gold and Silver
      2. Cost of Platinum Seat is 320
      3. Cost of Gold Seat is 280
      4. Cost of Silver Seat is 240
    instruction
end

end

booking = Booking.new.book_now