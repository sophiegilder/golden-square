class MusicTracker
  def initialize
    @list_of_tracks = []
  end

  def add_track(track)
    if track == ""
      fail "Please enter a track"
    elsif @list_of_tracks.include?(track)
      fail "You must love this song!"
    else
      @list_of_tracks << track
    end
  end

  def display_list
    @list_of_tracks.empty? ? "Playlist is empty" : @list_of_tracks
  end
end