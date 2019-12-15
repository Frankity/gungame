function loadScoreBoardData(data){
    if (typeof data == 'object'){
        data = Object.values(data)
    }

    removeOldData();

    var cars = ["Saab", "Volvo", "BMW"];

    for (let d = 0; d < data.length; d++){
        let player = data[d];
        let td = '<tr><td>' + player.name + '</td><td style="text-align: right;">testweapon</td><td style="text-align: right;">' + player.score +  '</td></tr>';
        let cont = document.getElementById("tablecontainer");
        cont.innerHTML += td;
    }
}

function removeOldData(){
    let cont = document.getElementById("tablecontainer");
    cont.innerHTML = '';
}