require "controllers/api/v1/test"

class Api::V1::NotesControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @note = build(:note, team: @team)
    @other_notes = create_list(:note, 3)

    @another_note = create(:note, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @note.save
    @another_note.save

    @original_hide_things = ENV["HIDE_THINGS"]
    ENV["HIDE_THINGS"] = "false"
    Rails.application.reload_routes!
  end

  def teardown
    super
    ENV["HIDE_THINGS"] = @original_hide_things
    Rails.application.reload_routes!
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(note_data)
    # Fetch the note in question and prepare to compare it's attributes.
    note = Note.find(note_data["id"])

    assert_equal_or_nil note_data["title"], note.title
    assert_equal_or_nil note_data["body"], note.body
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal note_data["team_id"], note.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/notes", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    note_ids_returned = response.parsed_body.map { |note| note["id"] }
    assert_includes(note_ids_returned, @note.id)

    # But not returning other people's resources.
    assert_not_includes(note_ids_returned, @other_notes[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/notes/#{@note.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/notes/#{@note.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    note_data = JSON.parse(build(:note, team: nil).api_attributes.to_json)
    note_data.except!("id", "team_id", "created_at", "updated_at")
    params[:note] = note_data

    post "/api/v1/teams/#{@team.id}/notes", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/notes",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/notes/#{@note.id}", params: {
      access_token: access_token,
      note: {
        title: "Alternative String Value",
        body: "Alternative String Value",
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @note.reload
    assert_equal @note.title, "Alternative String Value"
    assert_equal @note.body, "Alternative String Value"
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/notes/#{@note.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Note.count", -1) do
      delete "/api/v1/notes/#{@note.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/notes/#{@another_note.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
