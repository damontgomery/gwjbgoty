require 'rubygems'
require 'json'

# Read in the file.
file = open('goty-raw.json')
json = file.read
data = JSON.parse(json)

sums = {}

# Iterate over the file.
data.each do |username, top10|

  top10.each_with_index do |game, index|
    # Some of the data has blank rows. We skip those.
    next if game === ""

    points = 10 - index

    # Create a record for the game if it's the first time seeing it.
    sums[game] = {'points' => 0, 'top' => 0, 'votes' => 0} if !sums.key?(game)

    # Count the number of votes.
    sums[game]['votes'] += 1

    # Add the points to the running total.
    sums[game]['points'] += points

    # Add a count if this is the first place rank.
    sums[game]['top'] += 1 if index === 0
  end
end

# Calculate the average.
sums.each do |game, info|
  # make points a float so that the returned value is a float
  info['avg'] = info['points'].to_f / info['votes']
end

output = {}

# Sort by points.
output['points'] = sums.sort_by {|game, info| -info['points']}
output['points'] = output['points'][0..12]

# Sort by first place votes.
output['top'] = sums.sort_by {|game, info| -info['top']}
output['top'] = output['top'][0..7]

# Sort by votes.
output['votes'] = sums.sort_by {|game, info| -info['votes']}
output['votes'] = output['votes'][0..7]

# Sort by average with at least 3 votes.
sumsMinThreeVotes = sums.select{|key, item| item['votes'] >= 3}
output['avg'] = sumsMinThreeVotes.sort_by {|game, info| -info['avg']}
output['avg'] = output['avg'][0..7]

# Output the file.
puts JSON.pretty_generate(output)
