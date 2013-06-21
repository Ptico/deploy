class ActiveRecord < Deploy::Recipe
  on :configure do |app|
    puts 'configure'
  end

  on :migrate do |app|
    puts 'migrate'
  end
end
