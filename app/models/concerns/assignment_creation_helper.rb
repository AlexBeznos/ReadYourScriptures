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
    days_with_plus = sum % self.duration
    book_index = 0
    book_chapter = 0
    arr = []
    rest_arr = []

    self.duration.times do |time|
      if time + 1 <= days_with_plus
        current_div = div + 1
      else
        current_div = div
      end

      hash = self.get_assignment_name(book_index, book_chapter, current_div)
      book_index = hash[:book_index]
      book_chapter = hash[:book_chapter]
      arr.push(hash[:name])
    end


    self.create_assignments_from_array(arr)
    self.toggle_active_partly
  end

  def get_assignment_name(current_book, current_chapter, div)
    book = self.books[current_book]

    if book.parts_number - current_chapter < div
      rest_arr = []
      first = true

      until div <= 0 do
        book = self.books[current_book]

        if first
          till = book.parts_number
          div = div - (book.parts_number - current_chapter)
          current_book += 1
          first = false
        else
          if (book.parts_number - current_chapter) < div
            till = book.parts_number
            div = div - (book.parts_number - current_chapter)
            current_book += 1
          else
            till = current_chapter + div
            cc = current_chapter + div
            div = 0
          end
        end

        str = gen_assignment_name(book.name, current_chapter + 1, till)
        rest_arr.push(str)
        current_chapter = cc ? cc : 0
      end

      return {:book_index => current_book, :book_chapter => current_chapter, :name => rest_arr.join(', ')}
    else
      return {:book_index => current_book, :book_chapter => current_chapter + div, :name => gen_assignment_name(book.name, current_chapter + 1, current_chapter + div)}
    end
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
    def gen_assignment_name(book_name, from, till)
      if from == till
        "#{book_name} #{from}"
      else
        "#{book_name} #{from} - #{till}"
      end
    end

end
