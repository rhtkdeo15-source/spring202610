
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>카테고리로 장소 검색하기</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=71ef78e784445915e0226f7093195eac&libraries=services"></script>
</head>

<body>
    <div id="app">
        <select v-model="category" @change="searchCategory">
            <option value="">:: 선택 ::</option>
            <option value="MT1">대형마트</option>
            <option value="CS2">편의점</option>
            <option value="PS3">어린이집, 유치원</option>
            <option value="SC4">학교</option>
            <option value="AC5">학원</option>
            <option value="PK6">주차장</option>
            <option value="OL7">주유소, 충전소</option>
            <option value="SW8">지하철역</option>
            <option value="BK9">은행</option>
            <option value="CT1">문화시설</option>
            <option value="AG2">중개업소</option>
            <option value="PO3">공공기관</option>
            <option value="AT4">관광명소</option>
            <option value="AD5">숙박</option>
            <option value="FD6">음식점</option>
            <option value="CE7">카페</option>
            <option value="HP8">병원</option>
            <option value="PM9">약국</option>
        </select>

        <div id="map" style="width:100%;height:350px;"></div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                category: '',
                map: null,
                ps: null,
                infowindow: null,
                markers: []
            };
        },

        methods: {
            fnInit: function() {
                let self = this;

                let container = document.getElementById('map');

                let options = {
                    center: new kakao.maps.LatLng(37.566826, 126.9786567),
                    level: 3
                };

                self.map = new kakao.maps.Map(container, options);

                self.ps = new kakao.maps.services.Places(self.map);

                self.infowindow = new kakao.maps.InfoWindow({
                    zIndex: 1
                });

                let mapTypeControl = new kakao.maps.MapTypeControl();

                self.map.addControl(
                    mapTypeControl,
                    kakao.maps.ControlPosition.TOPRIGHT
                );

                let zoomControl = new kakao.maps.ZoomControl();

                self.map.addControl(
                    zoomControl,
                    kakao.maps.ControlPosition.RIGHT
                );
            },

            searchCategory: function() {
                let self = this;

                if (self.category === '') {
                    self.removeMarker();
                    return;
                }

                self.removeMarker();
                self.infowindow.close();

                self.ps.categorySearch(
                    self.category,
                    function(data, status, pagination) {
                        self.placesSearchCB(data, status, pagination);
                    },
                    {
                        useMapBounds: true
                    }
                );
            },

            placesSearchCB: function(data, status, pagination) {
                let self = this;

                if (status === kakao.maps.services.Status.OK) {

                    for (let i = 0; i < data.length; i++) {
                        self.displayMarker(data[i]);
                    }

                } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

                    alert('검색 결과가 존재하지 않습니다.');

                } else if (status === kakao.maps.services.Status.ERROR) {

                    alert('검색 중 오류가 발생했습니다.');

                }
            },

            displayMarker: function(place) {
                let self = this;

                let marker = new kakao.maps.Marker({
                    map: self.map,
                    position: new kakao.maps.LatLng(place.y, place.x)
                });

                self.markers.push(marker);

                kakao.maps.event.addListener(marker, 'click', function() {

                    self.infowindow.setContent(
                        '<div style="padding:5px;font-size:12px;">'
                        + place.place_name +
                        '</div>'
                    );

                    self.infowindow.open(self.map, marker);
                });
            },

            removeMarker: function() {
                let self = this;

                for (let i = 0; i < self.markers.length; i++) {
                    self.markers[i].setMap(null);
                }

                self.markers = [];
            }
        },

        mounted() {
            let self = this;

            self.fnInit();
        }
    });

    app.mount('#app');
</script>
