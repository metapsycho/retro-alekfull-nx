import QtQuick 2.15

Item {
    property string genreText: {
        if (currentGame === null) return '';
        if (currentGame.genreList.length === 0) { return ''; }

        const genre = currentGame.genreList[0] ?? '';
        const split = genre.split(',');

        if (split[0].length === 0) { return null; }

        return split[0];
    }

    property string lastPlayedText: {
        if (currentGame === null) return '';

        const lastPlayed = currentGame.lastPlayed.getTime();
        if (isNaN(lastPlayed)) return 'never played';

        const now = new Date().getTime();

        let time = Math.floor((now - lastPlayed) / 1000);
        if (time < 60) {
            return 'played ' + time + ' seconds ago';
        }

        time = Math.floor(time / 60);
        if (time < 60) {
            return 'played ' + time + ' minutes ago';
        }

        time = Math.floor(time / 60);
        if (time < 24) {
            return 'played ' + time + ' hours ago';
        }

        time = Math.floor(time / 24);
        return 'played ' + time + ' days ago';
    }

    property string releaseDateText: {
        if (currentGame === null) return '';
        if (!currentGame.releaseYear) return '';

        return 'released ' + currentGame.releaseYear;
    }

    property string playersText: {
        if (currentGame === null) return '';
        if (currentGame.players === 1) return '1 player';

        return currentGame.players + ' players';
    }

    property var ratingText: {
        if (currentGame === null) return '';
        if (currentGame.rating === 0) return '';

        let stars = [];
        const rating = Math.round(currentGame.rating * 500) / 100;

        for (let i = 0; i < 5; i++) {
            if (rating - i <= 0) {
                stars.push(glyphs.emptyStar);
            } else if (rating - i < 1) {
                stars.push(glyphs.halfStar);
            } else {
                stars.push(glyphs.fullStar);
            }
        }

        return stars.join(' ');
    }

    property string developedByText: {
        if (currentGame === null) return '';

        if (currentGame.developer) {
            return 'developed by ' + currentGame.developer;
        }

        if (currentGame.publisher) {
            return 'published by ' + currentGame.publisher;
        }

        return '';
    }
}
