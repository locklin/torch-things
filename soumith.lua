numStrings = 10 -- for example, lets do 10, but this number can be anything upto memory limits
maxStringLength = 100 -- this has to be predetermined
 
-- allocate CharTensor
bigStringTensor = torch.CharTensor(numStrings, maxStringLength)
bst_data=torch.data(bigStringTensor) -- raw C pointer using torchffi
 
-- load some strings into the stringTensor
str='hello world'
 
-- write strings to tensor
for i=1,bigStringTensor:size(1) do
local stri = str .. ' ' .. i
ffi.copy(bst_data + ((i-1) * maxStringLength), stri)
end
 
-- read back data gotcha (torchffi seems to always return the parent tensor's data pointer)
for i=1,bigStringTensor:size(1) do
print(ffi.string(torch.data(bigStringTensor[i])))
end
 
-- read back properly
for i=1,bigStringTensor:size(1) do
print(ffi.string(bst_data + ((i-1) * maxStringLength)))
end