#!/usr/bin/env ruby

require 'bart_waiting_list'
require 'fileutils'
require 'mail'

CONFIG_FILE = File.expand_path "#{__FILE__}/../config.yaml"
LAST_FILE = File.expand_path "#{__FILE__}/../last.txt"

# bail if we don't have a config file
unless File.exists? CONFIG_FILE
  abort "#{CONFIG_FILE} not found. Please copy config.example.yaml to "\
        "#{CONFIG_FILE} and fill out your credentials."
end

# config file needs to have mode 600, or bail
unless File.stat(CONFIG_FILE).mode & 600 == 0
  abort "Config file does not have proper permissions. Please chmod 600 #{CONFIG_FILE}"
end

# make sure we have a LAST_FILE
FileUtils.touch LAST_FILE

# get the waiting list position
config = YAML.load_file CONFIG_FILE
waiting_list = BartWaitingList.new config['creds']['email'], config['creds']['password']
position = waiting_list.get_waiting_list_position config['station'].to_sym

# read the last position from LAST_FILE
last_position = File.read LAST_FILE

# if it changed, holla
if position.to_s != last_position
  # TODO: this feels wrong
  Mail.defaults { delivery_method :smtp, :enable_starttls_auto => false }

  # send an email
  Mail.deliver do
    from config['deliver']['from']
    to config['deliver']['to']
    subject "BART waiting list position changed to #{position}"
    body "Your position in the BART parking waiting list is now #{position}."
  end

  # remember what the new position is
  File.write LAST_FILE, position
end

