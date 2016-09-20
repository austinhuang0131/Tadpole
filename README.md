# Tadpole Revived
* You are only allowed to use it privately.
  * That means, you must disable `Public Bot` option in your application page.
* You should contact [Snazzah](https://discord.gg/0vjTDaDsgOQWUtlv) for bugs, not me. He owns most of the code. I did some really minor changes (Disabling >2 way connection and changed prefix).
* You should NOT change any of the code except the token and app ID part. 
* Apache License 2.0

## How to use it
### Prepare it
You should have Ruby 2.3 or later. If not, get one.

**1** Download the whole repo.

**2** Execute them in your terminal:
```
$ gem install discordrb
$ gem install htmlentities
```

**3** You can see the following in tadpole.rb. Replace them.
```ruby
getatoken = "PUT YOUR TOKEN HERE"
getanapp = 224662505157427200 # REPLACE WITH YOUR APPLICATION ID
```

### Run it
```
$ cd <Where you put the repo>
$ ruby tadpole.rb
```

### Commands

**Requires `Tadpole Operator` role.**

Command | Description
----- | ----- 
`tadpole host` | Host a 5-way connection 
`tadpole join [Key]` | Join one
`tadpole end` | Kill your connection
`tadpole cinfo` | Check your connection

You can connect up to 5 servers. But >3 connected servers may result lag (failed to transfer messages).
