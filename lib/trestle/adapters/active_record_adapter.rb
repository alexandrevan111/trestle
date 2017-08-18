module Trestle
  module Adapters
    module ActiveRecordAdapter
      def collection(params={})
        model.all
      end

      def find_instance(params)
        model.find(params[:id])
      end

      def build_instance(attrs={}, params={})
        model.new(attrs)
      end

      def update_instance(instance, attrs, params={})
        instance.assign_attributes(attrs)
      end

      def save_instance(instance)
        instance.save
      end

      def delete_instance(instance)
        instance.destroy
      end

      def unscope(scope)
        scope.unscoped
      end

      def merge_scopes(scope, other)
        scope.merge(other)
      end

      def count(collection)
        collection.count
      end

      def sort(collection, field, order)
        collection.reorder(field => order)
      end

      def default_table_attributes
        default_attributes.reject do |attribute|
          inheritance_column?(attribute) || counter_cache_column?(attribute)
        end
      end

      def default_form_attributes
        default_attributes.reject do |attribute|
          primary_key?(attribute) || inheritance_column?(attribute) || counter_cache_column?(attribute)
        end
      end

    protected
      def default_attributes
        model.columns.map do |column|
          if column.name.end_with?("_id") && (reflection = model.reflections[column.name.sub(/_id$/, '')])
            Attribute::Association.new(column.name, reflection.klass)
          else
            Attribute.new(column.name, column.type)
          end
        end
      end

      def primary_key?(attribute)
        attribute.name.to_s == model.primary_key
      end

      def inheritance_column?(attribute)
        attribute.name.to_s == model.inheritance_column
      end

      def counter_cache_column?(attribute)
        attribute.name.to_s.end_with?("_count")
      end
    end
  end
end
