
Given("that user {string} with password {string} has logged in") do |string, string2|
	visit(new_session_path)
	fill_in('login', with: string)
	fill_in('password', with: string2)
	click_button('LoginTest')
end


When("the user creates a new anonymous thread with the title {string} with the body {string}") do |string, string2|
	visit(posts_path)
	click_button(id:'CreateNewPost')
	fill_in('Title', with: string)
	fill_in('Body', with: string2)
	check ('post_is_anon')
	click_button('Create Post')
end


Then("the current page should contain a new row containing the data:") do |table|
  results = [['Title', 'Author', 'Unread posts', 'Total number posts']] +
      page.all('tr.data').map {|tr|
        [tr.find('.title').text,
         tr.find('.author').text,
         tr.find('.unreadPosts').text,
         tr.find('.totalPosts').text]
      }
  table.diff!(results)
end