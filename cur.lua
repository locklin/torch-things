-- Pseudo-inverse
-- x is supposed to be MxN matrix, where M samples(trials) and each sample(trial) is N dim
-- returns Generalized inverse (also called the Moore-Penrose pseudo-inverse)
-- defined for all real or complex matrices
function pinv(x)
   local u,s,v = torch.svd(x,'A')
   local idx = torch.sum(torch.gt(s,0))
   local stm = s:pow(-1):narrow(1,1,idx)
   local n = stm:size()[1]
   local ss=torch.expand(torch.reshape(stm,n,1),n,n) -- for elementwise mult
   local vv = v:narrow(1,1,idx)
   local uu = u:narrow(1,1,idx)
   local pin = torch.mm(vv,torch.cmul(uu:t(),ss))   
   return pin
end

-- lin.cur
-- x is supposed to be MxN matrix, where M samples(trials) and each sample(trial) is N dim
-- returns the c, u, r decomposition using standard svd
function cur(x,k,r,c,ty)
   local u,s,v = svd(x)
   local cx,cs=levscore(x,k,c,v,ty)
   local rx,rs=levscore(x,k,r,u,ty)
   local R = idxselect(x,rx,2)
   local C = idxselect(x,cx,1)
   return C,U,R,cs,rs,cx,rx
end

--local function?
function levscore(x,k,c,v,ty)
   local score = ((torch.sum(torch.pow(x:narrow(2,1,k),2),1)/k)*c):squeeze()
   if ty=="random" then
      local idx = torch.ge(score,torch.rand(score:size()[1]))
      local sc = score[idxb]:narrow(1,1,idx:sum())
   elseif ty=="randex" then
      local scc,idxb = torch.sort(score-torch.rand(score:size()[1]),1,true)
      local idx = idxb:narrow(1,1,c)
      local sc = scc:narrow(1,1,c)
   elseif ty=="ord" then
      local scc, idxb = torch.sort(score,1,true)
      local idx = idxb:narrow(1,1,c)
      local sc = scc:narrow(1,1,c)
   end
   return idx,sc
end


--need a test script to check for correctness
