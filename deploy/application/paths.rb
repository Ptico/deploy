module Deploy
  class Application
    class Paths
      attr_reader :root, :repo, :shared, :releases, :current

      def each(&block)
        enums.each(&block)
      end

      def current_release
        releases.join(current_release_num.to_s)
      end

      def next_release
        releases.join((current_release_num + 1).to_s)
      end

    private

      attr_reader :enums

      def initialize(root_path)
        @root     = root_path
        @repo     = root_path.join('git')
        @shared   = root_path.join('shared')
        @releases = root_path.join('releases')
        @current  = root_path.join('current')

        @enums = [repo, shared, releases].freeze
        freeze
      end

      def current_release_num
        (Dir.entries(releases).each(&:to_i).sort.last || 1).to_i
      end
    end
  end
end
