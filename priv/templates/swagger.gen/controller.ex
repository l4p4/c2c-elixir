
  use PhoenixSwagger

  swagger_path :index do
    get "/api/<%= schema.plural %>"
    summary "List <%= schema.plural %>"
    description "List all <%= schema.plural %> in the database"
    tag "<%= inspect schema.alias %>s"
    produces "application/json"
    response(200, "OK", Schema.ref(:<%= inspect schema.alias %>sResponse),
      example: %{
        data: [
          %{
            id: 1,
            <%= schema.params.create |> Enum.map(fn {key, val} -> "#{key}: #{inspect(val)}" end) |> Enum.join(",\n") %>,
          }
        ]
      }
    )
  end

  swagger_path :create do
    post "/api/<%= schema.plural %>"
    summary "Create <%= schema.singular %>"
    description "Creates a new <%= schema.singular %>"
    tag "<%= inspect schema.alias %>s"
    consumes "application/json"
    produces "application/json"

    parameter(:<%= schema.singular %>, :body, Schema.ref(:<%= inspect schema.alias %>Request), "The <%= schema.singular %> details",
      example: %{
        <%= schema.singular %>: %{<%= schema.params.create |> Enum.map(fn {key, val} -> "#{key}: #{inspect(val)}" end) |> Enum.join(", ") %>}
      }
    )

    response(201, "<%= inspect schema.alias %> created OK", Schema.ref(:<%= inspect schema.alias %>Response),
      example: %{
        data: %{
          id: 1,
          <%= schema.params.create |> Enum.map(fn {key, val} -> "#{key}: #{inspect(val)}" end) |> Enum.join(",\n") %>,
        }
      }
    )
  end

  swagger_path :show do
    get "/api/<%= schema.plural %>/{id}"
    summary "Show <%= inspect schema.alias %>"
    description "Show a <%= schema.singular %> by ID"
    tag "<%= inspect schema.alias %>s"
    produces "application/json"
    parameter :id, :path, :integer, "<%= inspect schema.alias %> ID", required: true, example: 123

    response(200, "OK", Schema.ref(:<%= inspect schema.alias %>Response),
      example: %{
        data: %{
          id: 123,
          <%= schema.params.create |> Enum.map(fn {key, val} -> "          #{key}: #{inspect(val)}" end) |> Enum.join(",\n") %>,
        }
      }
    )
  end

  swagger_path :update do
    put "/api/<%= schema.plural %>/{id}"
    summary "Update <%= schema.singular %>"
    description "Update all attributes of a <%= schema.singular %>"
    tag "<%= inspect schema.alias %>s"
    consumes "application/json"
    produces "application/json"

    parameters do
      id(:path, :integer, "<%= inspect schema.alias %> ID", required: true, example: 3)

      <%= schema.singular %>(:body, Schema.ref(:<%= inspect schema.alias %>Request), "The <%= schema.singular %> details",
        example: %{
          <%= schema.singular %>: %{<%= schema.params.create |> Enum.map(fn {key, val} -> "#{key}: #{inspect(val)}" end) |> Enum.join(", ") %>}
        }
      )
    end

    response(200, "Updated Successfully", Schema.ref(:<%= inspect schema.alias %>Response),
      example: %{
        data: %{
          id: 3,
          <%= schema.params.create |> Enum.map(fn {key, val} -> "#{key}: #{inspect(val)}" end) |> Enum.join(",\n") %>,
        }
      }
    )
  end

  swagger_path :delete  do
    PhoenixSwagger.Path.delete "/api/<%= schema.plural %>/{id}"
    summary "Delete <%= inspect schema.alias %>"
    description "Delete a <%= schema.singular %> by ID"
    tag "<%= inspect schema.alias %>s"
    parameter :id, :path, :integer, "<%= inspect schema.alias %> ID", required: true, example: 3
    response 203, "No Content - Deleted Successfully"
  end

  def swagger_definitions do
  %{
    <%= inspect schema.alias %>: swagger_schema do
      title "<%= inspect schema.alias %>"
      description "A <%= schema.singular %> of the app"

      properties do
        id :integer, "<%= inspect schema.alias %> ID"
        <%= schema.params.create |> Enum.map(fn {key, _val} -> ~s(#{key} :string, "#{inspect schema.alias} #{key}") end) |> Enum.join("\n") %>
      end

      example(%{
        id: 123,
        <%= schema.params.create |> Enum.map(fn {key, val} -> "#{key}: #{inspect(val)}" end) |> Enum.join(",\n") %>,
      })
    end,
    <%= inspect schema.alias %>Request: swagger_schema do
      title "<%= inspect schema.alias %>Request"
      description "POST body for creating a <%= schema.singular %>"
      property :<%= schema.singular %>, Schema.ref(:<%= inspect schema.alias %>), "The <%= schema.singular %> details"
      example(%{
        <%= schema.singular %>: %{
          <%= schema.params.create |> Enum.map(fn {key, val} -> "#{key}: #{inspect(val)}" end) |> Enum.join(",\n") %>,
        }
      })
    end,
    <%= inspect schema.alias %>Response: swagger_schema do
      title "<%= inspect schema.alias %>Response"
      description "Response schema for single <%= schema.singular %>"
      property :data, Schema.ref(:<%= inspect schema.alias %>), "The <%= schema.singular %> details"
    end,
    <%= inspect schema.alias %>sResponse: swagger_schema do
      title "<%= inspect schema.alias %>Response"
      description "Response schema for multiple <%= schema.plural %>"
      property :data, Schema.array(:<%= inspect schema.alias %>), "The <%= schema.plural %> details"
    end
  }
  end
