module SecretSanta
  class Matches
    def initialize(matches)
      @matches = matches.map { |match| Match.new(match[0], match[1]) }
      self.notify_givers
    end

    def notify_givers
      @matches.each { |match| match.notify_giver }
    end
  end

  class Match
    attr_reader :giver, :receiver

    def initialize(giver, receiver)
      @giver = giver
      @receiver = receiver
    end

    def notify_giver
      Resque.enqueue(Notify, self)
    end
  end

  class Participants
    def initialize(participants)
      @participants = participants.map { |p| Participant.new(p[0], p[1]) }.shuffle
    end

    def match
      Matches.new(merge_arrays(@participants, offset_arr(@participants.clone)))
    end

    private
      def merge_arrays(participants, participants_clone)
        participants.zip(participants_clone)
      end

      def offset_arr(arr)
        arr.push(arr.slice! 0)
      end
  end

  class Participant
    attr_reader :name, :email_address

    def initialize(name, email_address)
      @name = name
      @email_address = email_address
    end
  end
end
