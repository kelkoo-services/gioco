def change_points(options)
  if Gioco::Core::KINDS
    points = options[:points]
    kind   = Kind.find(options[:kind])
  else
    points = options
    kind   = false
  end

  if Gioco::Core::KINDS
    raise "Missing Kind Identifier argument" if !kind
    old_pontuation = self.points(kind: kind.id)
  else
    old_pontuation = self.points
  end

  new_pontuation = old_pontuation + points
  Gioco::Core.sync_resource_by_points(self, new_pontuation, kind)
end

def next_badge?(kind_id = false)
  if Gioco::Core::KINDS
    raise "Missing Kind Identifier argument" if !kind_id
    old_pontuation = self.points(kind: kind_id)
  else
    old_pontuation = self.points
  end

  next_badge       = Badge.where("points > #{old_pontuation}").order("points ASC").first
  last_badge_point = self.badges.last.try('points')
  last_badge_point ||= 0

  if next_badge
    percentage      = (old_pontuation - last_badge_point)*100/(next_badge.points - last_badge_point)
    points          = next_badge.points - old_pontuation
    next_badge_info = {
                        :badge      => next_badge,
                        :points     => points,
                        :percentage => percentage
                      }
  end
end

def points(kind: false)
  key = "badges:#{self.id}"
  key += ":#{kind}" if kind
  $redis.get(key).to_i || 0
end

def incr_points(kind: false, pontuation:)
  key = "badges:#{self.id}"
  key += ":#{kind}" if kind
  $redis.set(key, pontuation)
end
