local function colshrink(x,idx)
   if idx:type() =='torch.ByteTensor' then
      return x:narrow(1,1,torch.sum(idx))
   else
      return x:narrow(1,1,idx)
   end
end


-- function selects d=2 rows by idx or d=1 cols by idx 
 function idxselect(x,d,idx)
   local dx = torch.range(1,idx:size()[1])[idx]:long()
   return x:index(d,dx)
end

