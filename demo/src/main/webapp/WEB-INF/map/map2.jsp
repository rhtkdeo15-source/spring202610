
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>키워드로 장소검색하고 목록으로 표출하기</title>

    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=71ef78e784445915e0226f7093195eac&libraries=services"></script>

    <style>
        .map_wrap, .map_wrap * {
            margin: 0;
            padding: 0;
            font-family: 'Malgun Gothic', dotum, '돋움', sans-serif;
            font-size: 12px;
        }

        .map_wrap a, .map_wrap a:hover, .map_wrap a:active {
            color: #000;
            text-decoration: none;
        }

        .map_wrap {
            position: relative;
            width: 100%;
            height: 500px;
        }

        #menu_wrap {
            position: absolute;
            top: 0;
            left: 0;
            bottom: 0;
            width: 250px;
            margin: 10px 0 30px 10px;
            padding: 5px;
            overflow-y: auto;
            background: rgba(255, 255, 255, 0.7);
            z-index: 1;
            font-size: 12px;
            border-radius: 10px;
        }

        .bg_white {
            background: #fff;
        }

        #menu_wrap hr {
            display: block;
            height: 1px;
            border: 0;
            border-top: 2px solid #5F5F5F;
            margin: 3px 0;
        }

        #menu_wrap .option {
            text-align: center;
        }

        #menu_wrap .option p {
            margin: 10px 0;
        }

        #menu_wrap .option button {
            margin-left: 5px;
        }

        #placesList li {
            list-style: none;
        }

        #placesList .item {
            position: relative;
            border-bottom: 1px solid #888;
            overflow: hidden;
            cursor: pointer;
            min-height: 65px;
        }

        #placesList .item span {
            display: block;
            margin-top: 4px;
        }

        #placesList .item h5,
        #placesList .item .info {
            text-overflow: ellipsis;
            overflow: hidden;
            white-space: nowrap;
        }

        #placesList .item .info {
            padding: 10px 0 10px 55px;
        }

        #placesList .info .gray {
            color: #8a8a8a;
        }

        #placesList .info .jibun {
            padding-left: 26px;
            background: url(https://t1.kakaocdn.net/localimg/localimages/07/mapapidoc/places_jibun.png) no-repeat;
        }

        #placesList .info .tel {
            color: #009900;
        }

        #placesList .item .markerbg {
            float: left;
            position: absolute;
            width: 36px;
            height: 37px;
            margin: 10px 0 0 10px;
            background: url(https://t1.kakaocdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png) no-repeat;
        }

        #placesList .item .marker_1 { background-position: 0 -10px; }
        #placesList .item .marker_2 { background-position: 0 -56px; }
        #placesList .item .marker_3 { background-position: 0 -102px; }
        #placesList .item .marker_4 { background-position: 0 -148px; }
        #placesList .item .marker_5 { background-position: 0 -194px; }
        #placesList .item .marker_6 { background-position: 0 -240px; }
        #placesList .item .marker_7 { background-position: 0 -286px; }
        #placesList .item .marker_8 { background-position: 0 -332px; }
        #placesList .item .marker_9 { background-position: 0 -378px; }
        #placesList .item .marker_10 { background-position: 0 -423px; }
        #placesList .item .marker_11 { background-position: 0 -470px; }
        #placesList .item .marker_12 { background-position: 0 -516px; }
        #placesList .item .marker_13 { background-position: 0 -562px; }
        #placesList .item .marker_14 { background-position: 0 -608px; }
        #placesList .item .marker_15 { background-position: 0 -654px; }

        #pagination {
            margin: 10px auto;
            text-align: center;
        }

        #pagination a {
            display: inline-block;
            margin-right: 10px;
        }

        #pagination .on {
            font-weight: bold;
            cursor: default;
            color: #777;
        }
    </style>
</head>

<body>
    <div id="app">
        <div class="map_wrap">
            <div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>

            <div id="menu_wrap" class="bg_white">
                <div class="option">
                    <div>
                        <form @submit.prevent="searchPlaces">
                            키워드 :
                            <input type="text" v-model="keyword" size="15">
                            <button type="submit">검색하기</button>
                        </form>
                    </div>
                </div>

                <hr>

                <ul id="placesList"></ul>

                <div id="pagination"></div>
            </div>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                keyword: '이태원 맛집',
                map: null,
                ps: null,
                markers: [],
                infowindow: null
            };
        },

        methods: {
            fnInit: function() {
                let self = this;

                let mapContainer = document.getElementById('map');

                let mapOption = {
                    center: new kakao.maps.LatLng(37.566826, 126.9786567),
                    level: 3
                };

                self.map = new kakao.maps.Map(mapContainer, mapOption);

                self.ps = new kakao.maps.services.Places();

                self.infowindow = new kakao.maps.InfoWindow({
                    zIndex: 1
                });

                self.searchPlaces();
            },

            searchPlaces: function() {
                let self = this;

                let keyword = self.keyword;

                if (!keyword.replace(/^\s+|\s+$/g, '')) {
                    alert('키워드를 입력해주세요!');
                    return false;
                }

                self.ps.keywordSearch(keyword, function(data, status, pagination) {
                    self.placesSearchCB(data, status, pagination);
                });
            },

            placesSearchCB: function(data, status, pagination) {
                let self = this;

                if (status === kakao.maps.services.Status.OK) {

                    self.displayPlaces(data);

                    self.displayPagination(pagination);

                } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

                    alert('검색 결과가 존재하지 않습니다.');

                } else if (status === kakao.maps.services.Status.ERROR) {

                    alert('검색 결과 중 오류가 발생했습니다.');

                }
            },

            displayPlaces: function(places) {
                let self = this;

                let listEl = document.getElementById('placesList');
                let menuEl = document.getElementById('menu_wrap');

                let fragment = document.createDocumentFragment();

                let bounds = new kakao.maps.LatLngBounds();

                self.removeAllChildNods(listEl);

                self.removeMarker();

                for (let i = 0; i < places.length; i++) {

                    let placePosition = new kakao.maps.LatLng(
                        places[i].y,
                        places[i].x
                    );

                    let marker = self.addMarker(placePosition, i);

                    let itemEl = self.getListItem(i, places[i]);

                    bounds.extend(placePosition);

                    (function(marker, title) {

                        kakao.maps.event.addListener(marker, 'mouseover', function() {
                            self.displayInfowindow(marker, title);
                        });

                        kakao.maps.event.addListener(marker, 'mouseout', function() {
                            self.infowindow.close();
                        });

                        itemEl.onmouseover = function() {
                            self.displayInfowindow(marker, title);
                        };

                        itemEl.onmouseout = function() {
                            self.infowindow.close();
                        };

                    })(marker, places[i].place_name);

                    fragment.appendChild(itemEl);
                }

                listEl.appendChild(fragment);

                menuEl.scrollTop = 0;

                self.map.setBounds(bounds);
            },

            getListItem: function(index, places) {
                let el = document.createElement('li');

                let marker = document.createElement('span');
                marker.className = 'markerbg marker_' + (index + 1);

                let info = document.createElement('div');
                info.className = 'info';

                let title = document.createElement('h5');
                title.textContent = places.place_name;

                info.appendChild(title);

                if (places.road_address_name) {

                    let roadAddress = document.createElement('span');
                    roadAddress.textContent = places.road_address_name;

                    let jibunAddress = document.createElement('span');
                    jibunAddress.className = 'jibun gray';
                    jibunAddress.textContent = places.address_name;

                    info.appendChild(roadAddress);
                    info.appendChild(jibunAddress);

                } else {

                    let address = document.createElement('span');
                    address.textContent = places.address_name;

                    info.appendChild(address);
                }

                let tel = document.createElement('span');
                tel.className = 'tel';
                tel.textContent = places.phone;

                info.appendChild(tel);

                el.appendChild(marker);
                el.appendChild(info);

                el.className = 'item';

                return el;
            },

            addMarker: function(position, idx, title) {
                let self = this;

                let imageSrc = 'https://t1.kakaocdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png';

                let imageSize = new kakao.maps.Size(36, 37);

                let imgOptions = {
                    spriteSize: new kakao.maps.Size(36, 691),
                    spriteOrigin: new kakao.maps.Point(0, (idx * 46) + 10),
                    offset: new kakao.maps.Point(13, 37)
                };

                let markerImage = new kakao.maps.MarkerImage(
                    imageSrc,
                    imageSize,
                    imgOptions
                );

                let marker = new kakao.maps.Marker({
                    position: position,
                    image: markerImage
                });

                marker.setMap(self.map);

                self.markers.push(marker);

                return marker;
            },

            removeMarker: function() {
                let self = this;

                for (let i = 0; i < self.markers.length; i++) {
                    self.markers[i].setMap(null);
                }

                self.markers = [];
            },

            displayPagination: function(pagination) {
                let self = this;

                let paginationEl = document.getElementById('pagination');

                let fragment = document.createDocumentFragment();

                self.removeAllChildNods(paginationEl);

                for (let i = 1; i <= pagination.last; i++) {

                    let el = document.createElement('a');

                    el.href = '#';
                    el.innerHTML = i;

                    if (i === pagination.current) {

                        el.className = 'on';

                    } else {

                        el.onclick = (function(i) {
                            return function() {
                                pagination.gotoPage(i);
                            };
                        })(i);
                    }

                    fragment.appendChild(el);
                }

                paginationEl.appendChild(fragment);
            },

            displayInfowindow: function(marker, title) {
                let self = this;

                let content = '<div style="padding:5px;z-index:1;">' + title + '</div>';

                self.infowindow.setContent(content);

                self.infowindow.open(self.map, marker);
            },

            removeAllChildNods: function(el) {
                while (el.hasChildNodes()) {
                    el.removeChild(el.lastChild);
                }
            }
        },

        mounted() {
            let self = this;

            self.fnInit();
        }
    });

    app.mount('#app');
</script>
