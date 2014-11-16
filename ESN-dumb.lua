require'nn'
require'csvigo'
trainLen = 2000
testLen = 2000
initLen = 100
inSize = 1
outSize = 1
resSize = 1000
a = 0.3
reg = 1e-8

data=torch.Tensor(csvigo.load{path='~/data/misc/MackeyGlass_t17.txt',separator=',',mode='raw',header=false,verbose=true}):t() --:squeeze()

Win = torch.rand(resSize,2)-0.5
W = torch.rand(resSize,resSize) - 0.5
ev= torch.eig(W,'N')
eva= math.sqrt(ev[{1,2}]^2 + ev[{1,1}]^2)
W = W * 1.25 / eva

X = torch.Tensor((1+inSize+resSize),(trainLen-initLen)):fill(0)
Yt = data:narrow(2,(initLen+1),(testLen- initLen))

x = torch.Tensor(resSize,1):fill(0)
for i = 1,trainLen do
   u = torch.cat(torch.ones(1),data[{{},i}],2)
   x = x*(1 -a)  + (torch.tanh(   torch.mm(Win,u:t())+ torch.mm(W,x) ) * a)
   if i > initLen then
      X[{{},{(i - initLen)}}]  = torch.cat(u:squeeze(),x)
   end
end
Wout = torch.mm(Yt,torch.mm(X:t(),torch.inverse(torch.mm(X,X:t()) + torch.eye(1+inSize + resSize) * reg)))
Y = torch.Tensor(outSize,testLen):fill(0)
u = data[{{},(trainLen + 1)}]

for i = 1,testLen do
   uu = torch.cat(torch.ones(1),u,2)
   x = x*(1-a) + (torch.tanh( torch.mm(Win,uu:t()) + torch.mm(W,x) ) * a)
   y = torch.mm(Wout, torch.cat(uu:t(),xx,1))
   Y[{{},{i}}] = y
   -- generative mode
   u = y
   -- below is predictive mode
   -- u = data[trainLen + i + 1]
end

errorLen = 500
diff =  data:narrow(2,(trainLen+1),(errorLen)) - Y:narrow(2,1,errorLen) 
mse = torch.dot(diff,diff)/errorLen
print( paste( 'MSE = ', mse ) )

