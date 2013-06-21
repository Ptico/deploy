class ActiveRecord < Deploy::Recipe
  on :configure do |app|
    puts 'cp shared/database.yml current/config/database.yml'
  end

  on :migrate do |app|
    puts 'rake db:migrate'
  end
end
