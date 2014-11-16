a=torch.randn(100,10)
fid=torch.DiskFile("blah.t7","w")
fid:writeObject(a)
fid:close()

b=torch.randn(20,3)
fid=torch.DiskFile("bblah.t7","w")
fid:writeObject(b)
fid:close()


c=torch.randn(20,13)
fid=torch.DiskFile("cblah.t7","w")
fid:writeObject(c)
fid:close()
