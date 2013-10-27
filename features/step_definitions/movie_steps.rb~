# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
  
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  page.body.index(e1).should < page.body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  if uncheck 
  	rating_list.split(%r{,\s*}).each do |rating|
    	step "I uncheck \"ratings_#{rating}\""
  	end
  else
  	rating_list.split(%r{,\s*}).each do |rating|
    	step "I check \"ratings_#{rating}\""
  	end
  end
end

#TODO:implement correctly
Then /I should see all the movies/ do 
  # Make sure that all the movies in the app are visible in the table
 	step "I should see: Aladdin, The Terminator, When Harry Met Sally, The Help, Chocolat, Amelie, 2001: A Space Odyssey, The Incredibles, Raiders of the Lost Ark, Chicken Run"
end

When /^I press (.*)$/ do |pressed|
        click_button(pressed)
end

Then /^I should see: (.*)$/ do |movie_titles|
	movie_titles.split(%r{,\s*}).each do |title|
		if page.respond_to? :should
		  page.should have_content(title)
		else
		  assert page.has_content?(title)
		end
	end
end

Then /^I shouldn't see: (.*)$/ do |movie_titles|
	movie_titles.split(%r{,\s*}).each do |title|
		if page.respond_to? :should
		  page.should have_no_content(title)
		else
		  assert page.has_no_content?(title)
		end
	end
end


