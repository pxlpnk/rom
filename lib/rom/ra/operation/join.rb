module ROM
  module RA
    class Operation

      class Join
        include Charlatan.new(:left)
        include Enumerable

        attr_reader :right

        def initialize(left, right)
          super
          @left, @right = left, right
        end

        def header
          left.header + right.header
        end

        def each(&block)
          return to_enum unless block

          join_map = right.each_with_object({}) { |tuple, h|
            other = left.detect { |t| (tuple.to_a & t.to_a).any?  }
            (h[other] ||= []) << tuple if other
          }

          tuples = left.map { |tuple|
            others = join_map[tuple]
            next unless others.any?
            others.map { |other| tuple.merge(other) }
          }.flatten

          tuples.each(&block)
        end

      end

    end
  end
end
