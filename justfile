format:
   find . -name "*.dart" -not -path "./lib/gen/*" | xargs dart format -l 120

gen-enforcer:
    buf generate --template buf.gen.yaml https://github.com/LayerTwo-Labs/cusf_sidechain_proto.git

gen: gen-enforcer
    buf generate ../../servers/bitwindow 
