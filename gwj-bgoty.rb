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
    sums[game] = {'points' => 0, 'top' => 0} if !sums.key?(game)

    # Add the points to the running total.
    sums[game]['points'] += points

    # Add a count if this is the first place rank.
    sums[game]['top'] += 1 if index === 0
  end
end

output = {}

# Sort by points.
output['points'] = sums.sort_by do |game, info|
  # Reverse the sort order.
  -info['points']
end

# Sort by first place votes.
output['top'] = sums.sort_by do |game, info|
  -info['top']
end

# Output the file.
puts JSON.generate(output)
