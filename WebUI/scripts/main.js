function loadScoreBoardData(data){
    if (typeof data == 'object'){
        data = Object.values(data)
    }

    removeOldData();

    for (let d = 0; d < data.length; d++){
        let player = data[d];
        let td = '<tr><td>' + player.name + '</td><td>testweapon</td><td>' + player.score +  '</td></tr>';
        let cont = document.getElementById("tablecontainer");
        cont.innerHTML += td;
    }
}

function removeOldData(){
    let cont = document.getElementById("tablecontainer");
    cont.innerHTML = '';
}