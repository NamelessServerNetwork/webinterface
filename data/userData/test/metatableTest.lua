local t = {
	t1 = "t1",
	t2 = "t2",
	t3 = "t3",
}

local mt = {
	mt1 = "mt1",
	mt2 = "mt2",
	mt3 = "mt3",
}

setmetatable(t, mt)

for i, c in pairs(t) do
	print(i, c)
end

mt.mt4 = "MT4"

for i, c in pairs(getmetatable(t)) do
	print(i, c)
end