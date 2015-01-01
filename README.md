# bart_waiting_list_checker.rb

This script will check your position in the BART parking waiting list on
select-a-spot.com and email you if it detects a change in your position. Written
with the intent of being run via cron.

## Usage

    $ git clone https://github.com/brianokeefe/bart_waiting_list_checker.git
    $ cd bart_waiting_list_checker/

    # get deps
    $ bundle install

    # set up your config
    $ cp config.example.yaml config.yaml
    $ chmod 600 config.yaml
    $ vim config.yaml  # change your settings!

Now add the script to your crontab and get an email automatically when you move
up in line for parking!

