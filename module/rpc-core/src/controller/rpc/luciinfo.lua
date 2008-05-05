module("ffluci.controller.rpc.luciinfo", package.seeall)

function action_index()
	local uci = ffluci.model.uci.StateSession()

	ffluci.http.set_content_type("text/plain")
	
	-- General
	print("luciinfo.api=1")
	print("luciinfo.version=" .. tostring(ffluci.__version__))
	
	-- Sysinfo
	local s, m, r = ffluci.sys.sysinfo()
	local dr = ffluci.sys.net.defaultroute()
	dr = dr and ffluci.sys.net.hexip4(dr.Gateway) or ""
	local l1, l5, l15 = ffluci.sys.loadavg()
	
	print("sysinfo.system=" .. sanitize(s))
	print("sysinfo.cpu=" .. sanitize(m))
	print("sysinfo.ram=" .. sanitize(r))
	print("sysinfo.hostname=" .. sanitize(ffluci.sys.hostname()))
	print("sysinfo.load1=" .. tostring(l1))
	print("sysinfo.load5=" .. tostring(l5))
	print("sysinfo.load15=" .. tostring(l15))
	print("sysinfo.defaultgw=" .. dr)

	
	-- Freifunk
	local ff = uci:sections("freifunk") or {}
	for k, v in pairs(ff) do
		if k:sub(1, 1) ~= "." then
			for i, j in pairs(v) do
				print("freifunk." .. k .. "." .. i .. "=" .. j)
			end
		end
	end
end

function sanitize(val)
	return val:gsub("\n", "\t")
end