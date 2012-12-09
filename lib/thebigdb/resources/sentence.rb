module TheBigDB
  module Resources
    class Sentence
      def self.get(id)
        TheBigDB.send_request(:get, "/sentences", :id => id)
      end

      def self.auto_complete(options = {})
        # TODO
      end

      def self.search(options = {})
        # TODO
      end

      def self.create(options = {})
        # TODO
      end

      def self.upvote(options = {})
        # TODO
      end

      def self.downvote(options = {})
        # TODO
      end

      def self.report(options = {})
        # TODO
      end

      def self.destroy(options = {})
        # TODO
      end

      class << self
        alias :autocomplete :auto_complete
        alias :show :get
      end
    end
  end
end