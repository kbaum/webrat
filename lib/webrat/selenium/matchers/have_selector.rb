module Webrat
  module Selenium
    module Matchers
      class HaveSelector
        def initialize(expected, options = {}, &block)
          @expected = expected
          @options  = options
          @block    = block
          @content  = @options.delete(:content)||@options.delete(:text)
        end

        def matches?(response)
          response.session.wait_for do
#            if @content
#              @element=response.selenium.get_text("css=#{@expected}")
#              case @content
#              when String
#                @element.include?(@content)
#              when Regexp
#                @element.match(@content)
#              end
#              
#            else
              response.selenium.is_element_present(selector)
#            end
          end
          rescue Webrat::TimeoutError
            false
        end
        
        def selector
          "css=#{@expected}" + (@content && ":contains('#{@content}')")
        end

        # ==== Returns
        # String:: The failure message.
        def failure_message
          "expected following text to match selector #{@expected}:\n#{@document}"
        end

        # ==== Returns
        # String:: The failure message to be displayed in negative matches.
        def negative_failure_message
          "expected following text to not match selector #{@expected}:\n#{@document}"
        end
      end

      # Matches HTML content against a CSS 3 selector.
      #
      # ==== Parameters
      # expected<String>:: The CSS selector to look for.
      #
      # ==== Returns
      # HaveSelector:: A new have selector matcher.
      def have_selector(name, attributes = {}, &block)
        HaveSelector.new(name, attributes, &block)
      end

      # Asserts that the body of the response contains
      # the supplied selector
      def assert_have_selector(expected, attributes = {})
        hs = HaveSelector.new(expected, attributes)
        assert hs.matches?(response), hs.failure_message
      end

      # Asserts that the body of the response
      # does not contain the supplied string or regepx
      def assert_have_no_selector(expected, attributes = {})
        hs = HaveSelector.new(expected, attributes)
        assert !hs.matches?(response), hs.negative_failure_message
      end
    end
  end
end
