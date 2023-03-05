file=/opt/whatsapp-nativefier/resources/app/nativefier.json

sudo sed -i "s,\(\"tray\":\)\"true\",\1\"start-in-tray\",g" $file
