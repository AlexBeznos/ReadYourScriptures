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

    self.update(active: true)
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
          arr.push("#{book.name} #{time == 0 ? '1 - ' + div.to_s : ((time * div) + 1).to_s + ' - ' + ((time * div) + div).to_s}")
        end

        mod = book.parts_number % div
      else
        if rest_books.empty?
          current_div = 0
          b = self.books[index - 1]
          rest_books.push("#{b.name} #{b.parts_number - mod + 1} - #{b.parts_number}")
        end

        current_div == 0 ? current_div = div - mod : current_div = mod

        if book.parts_number < current_div
          rest_books.push("#{book.name} 1 - #{book.parts_number}")
          mod = current_div - book.parts_number
        else
          rest_books.push("#{book.name} 1 - #{current_div}")
          arr.push(rest_books.join(', '))
          rest_books = []

          ((book.parts_number - current_div) / div).times do |time|
            arr.push("#{book.name} #{time == 0 ? (current_div + 1).to_s + ' - ' + (div + current_div).to_s : ((time * div) + 1 + mod).to_s + ' - ' + ((time * div) + div + mod).to_s}")
          end

          mod = (book.parts_number - current_div) % div
        end
      end
    end

    self.create_assignments_from_array(arr)
    self.update(active: true)
  end

  def create_assignments_from_array(arr)
    arr.each_with_index do |name, index|
      Assignment.create(name: name,
                        sending_date: self.start_date + index,
                        schedule_id: self.id)
    end
  end
end
