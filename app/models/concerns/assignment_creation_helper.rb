module AssignmentCreationHelper
  def create_part_per_day_assignments
    day_from_start = -1
    self.books.each do |book|
      book.parts_number.times do |time|
        day_from_start += 1
        Assignment.create(name: "#{book.name} #{time + 1}",
                          sending_date: self.start_date + day_from_start,
                          schedule_id: self.id)
      end
    end

    self.toggle_active_partly
  end

  def create_regular_assignments(sum)
    div = sum / self.duration
    current_div = 0
    rest_books = []
    arr = []
    mod = 0

    self.books.each_with_index do |book, index|
      if mod == 0
        number_of_times = book.parts_number / div

        number_of_times.times do |time|
          arr.push(gen_assignment_name(book.name, time, div, ((time * div) + 1), ((time * div) + div)))
        end

        mod = book.parts_number % div
      else
        if rest_books.empty?
          current_div = 0
          b = self.books[index - 1]
          rest_books.push(gen_assignment_name(b.name, 1, 1, (b.parts_number - mod + 1), b.parts_number))
        end

        current_div == 0 ? current_div = div - mod : current_div = mod

        if book.parts_number < current_div
          rest_books.push(gen_assignment_name(book.name, 0, book.parts_number))
          mod = current_div - book.parts_number
        else
          rest_books.push(gen_assignment_name(book.name, 0, current_div))
          arr.push(rest_books.join(', '))
          rest_books = []

          ((book.parts_number - current_div) / div).times do |time|
            arr.push(gen_assignment_name(book.name, time, (current_div + 1), ((time * div) + 1 + mod), ((time * div) + div + mod), (div + current_div), true))
          end

          mod = (book.parts_number - current_div) % div
        end
      end
    end

    self.create_assignments_from_array(arr)
    self.toggle_active_partly
  end


  def create_assignments_from_array(arr)
    arr.each_with_index do |name, index|
      Assignment.create(name: name,
                        sending_date: self.start_date + index,
                        schedule_id: self.id)
    end
  end

  def toggle_active_partly
    self.update(active: user.activated, ready: true)
  end

  private
    def gen_assignment_name(name, time, first, from = false, to = false, first_second = false, cust = false)
      if time == 0
        if cust
          parts = first == first_second ? first.to_s : "#{first} - #{first_second}"
        else
          parts = first == 1 ? '1' : "1 - #{first.to_s}"
        end

        return "#{name} #{parts}"
      else
        parts = from == to ? from : "#{from.to_s} - #{to.to_s}"
        return "#{name} #{parts}"
      end
    end

end
