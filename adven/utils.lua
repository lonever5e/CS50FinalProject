function collision(entity1, entity2)
  if entity1.y + entity1.height >= entity2.y and
    entity1.y <= entity2.y + entity2.height and
    entity1.x <= entity2.x + entity2.width and
    entity1.x + entity1.width >= entity2.x then
      return true
  else
      return false
  end
end

function platformCollision(entity1, entity2)
  if entity1.y + entity1.height >= entity2.y and
    entity1.y + entity1.height <= entity2.y + entity2.height and
    entity1.x <= entity2.x + entity2.width and
    entity1.x + entity1.width >= entity2.x then
      return true
  else
      return false
  end
end

function table.slice(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced+1] = tbl[i]
  end
  
  return sliced
end