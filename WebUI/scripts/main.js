function loadScoreBoardData(data) {

    if (typeof data == 'object') {
        data = Object.values(data).sort(function (a, b) {
            if (a.score > b.score) {
                return -1
            }
        })
    }

    removeOldData();

    for (let d = 0; d < data.length; d++) {
        let player = data[d];
        let td = '<tr><td>' + player.name + '</td><td style="text-align: right;">' + player.score + '</td><td style="text-align: right;">' + player.ping + '</td></tr>';
        let cont = document.getElementById("tablecontainer");
        cont.innerHTML += td;
    }
}

function removeOldData() {
    let cont = document.getElementById("tablecontainer");
    cont.innerHTML = '';
}

function showScoreBoard() {
    $('#scoreContainer').css('display', 'block');
}

function hideScoreBoard() {
    $('#scoreContainer').css('display', 'none');
}