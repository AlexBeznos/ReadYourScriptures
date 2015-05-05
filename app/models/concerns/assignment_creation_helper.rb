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

    self.toggle
  end

  def create_regular_assignments(sum)
    div = sum / self.duration
    mod = sum % self.duration
    names = []

    self.gen_assignments_with_mod(0, div, mod, 0, first: true)
    self.toggle
  end

  def gen_assignments_with_mod(book_num, div, mod, day_from, **prev)
    book = self.books[book_num]
    if book
      sum = div + mod
      with_mod = false

      if mod != 0
        if book.parts_number > sum
          if prev[:first]
            Assignment.create(name: "#{book.name} 1 - #{sum}",
                              sending_date: self.start_date + day_from,
                              schedule_id: self.id)
          else
            Assignment.create(name: "#{prev[:book_name]} #{prev[:part]} - #{book.name} #{sum}",
                              sending_date: self.start_date + day_from,
                              schedule_id: self.id)
          end

          day_from += 1
          with_mod = true
        else
          if prev[:first]
            hash = {:book_name => book.name, :part => 1}
          else
            hash = prev
          end
          return self.gen_assignments_with_mod(book_num + 1, div, mod - book.parts_number, day_from, hash )
        end
      end


      if with_mod
        names_array = self.gen_names_array( book: book,
                                            number_of_times: ((book.parts_number - sum) / div),
                                            div: div,
                                            mod: mod,
                                            part: sum)
        new_mod = (book.parts_number - sum) % div
      else
        names_array = self.gen_names_array( book: book,
                                            number_of_times: ((book.parts_number / div) - 1),
                                            div: div,
                                            part: sum)
        new_mod = book.parts_number % div
      end

      new_day_from = self.create_assignments_from_array(names_array[:arr], day_from)


      hash = {}
      unless new_mod == 0
        hash =  {:book_name => book.name, :part => names_array[:till]}
      end

      self.gen_assignments_with_mod(book_num + 1, div, new_mod, new_day_from, hash)
    end
  end

  def create_assignments_from_array(arr, day_from)
    arr.each do |name|
      Assignment.create(name: name, sending_date: self.start_date + day_from, schedule_id: self.id)
      day_from += 1
    end

    day_from
  end

  def gen_names_array(**hash)
    arr = []

    till = 0
    hash[:number_of_times].times do |time|
      real_time = time + 1

      if hash[:mod]
        from = real_time == 1 ? (hash[:div] + hash[:mod]) : (real_time * hash[:div]) + hash[:mod]
      else
        from = real_time == 1 ? 1 : real_time * hash[:div]
      end

      till = from + hash[:div]
      arr.push("#{hash[:book].name} #{ from } - #{ till }")
    end

    till = hash[:part] if till == 0
    {:arr => arr, :till => till}
  end
end
