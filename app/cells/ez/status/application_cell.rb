# frozen_string_literal: true

module Ez
  module Status
    class ApplicationCell < Cell::ViewModel
      self.view_paths = ["#{Ez::Status::Engine.root}/app/cells"]

      CSS_SCOPE = 'ez-status'

      def div_for(item, &block)
        content_tag :div, class: css_for(item), &block
      end

      def css_for(item)
        scoped_item = "#{CSS_SCOPE}-#{item}"

        custom_css_map[scoped_item] || scoped_item
      end

      def css_for_column_name(item)
        item.gsub!(/_/, '-')
        css_for(item)
      end

      def custom_css_map
        @custom_css_map ||= Ez::Status.config.ui_custom_css_map || {}
      end
    end
  end
end
