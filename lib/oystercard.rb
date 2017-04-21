
class Oystercard

  attr_reader :balance, :entry, :exit, :journeys, :current_journey

  def initialize(balance = 0)
    @balance = balance
    @entry = nil
    @exit = nil
    @journeys = []
  end

  def top_up(amount = 0)
    raise "Top-up over max balance £#{MAX_BALANCE}" if exceed_balance?(amount)
    increment_balance(amount)
  end

  def in_journey?
    !!@entry
  end

  def touch_in(entry_station)
    raise 'Not enough funds' if balance < LOW_BALANCE
    raise 'Already travelling' if in_journey?
    change_journey_status
    @entry = entry_station
    @current_journey = Journey.new
    @current_journey.start_journey(entry_station)
  end

  def touch_out(exit_station)
    raise 'ERROR! Not travelling!' if in_journey? == false
    change_journey_status
    deduct(FARE)
    @exit = exit_station
    add_journey
    reset_journey
  end

  private

  MAX_BALANCE = 100
  LOW_BALANCE = 1
  FARE = 2

  def exceed_balance?(amount)
    @balance + amount > MAX_BALANCE
  end

  def increment_balance(amount)
    @balance += amount
  end

  def deduct(fare)
    @balance -= fare
  end

  def add_journey
     @journeys << { entry: @entry, exit: @exit }
  end

  def reset_journey
    @entry, @exit = nil
  end

  def change_journey_status
    return @in_journey = false if in_journey?
    return @in_journey = true if in_journey? == false
  end
end
