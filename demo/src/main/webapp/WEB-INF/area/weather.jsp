
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>지역 선택</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    <style>
        table, tr, td, th {
            border: 1px solid black;
            border-collapse: collapse;
            padding: 5px 10px;
            text-align: center;
        }

        th {
            background-color: beige;
        }

        tr:nth-child(even) {
            background-color: azure;
        }
    </style>
</head>
<body>

<div id="app">
    <div>
        <select @change="fnGuList" v-model="si">
            <option value="">:: 선택 ::</option>
            <option v-for="item in siList" :value="item.si">
                {{item.si}}
            </option>
        </select>

        <select @change="fnDongList" v-model="gu">
            <option value="">:: 선택 ::</option>
            <option v-for="item in guList" :value="item.gu">
                {{item.gu}}
            </option>
        </select>

        <select v-model="dong" @change="fnGetWeather">
            <option value="">:: 선택 ::</option>
            <option v-for="item in dongList" :value="item">
                {{item.dong}}
            </option>
        </select>
    </div>
</div>

<script>
    const app = Vue.createApp({
        data() {
            return {
                siList: [],
                guList: [],
                dongList: [],
                si: "",
                gu: "",
                dong: {}
            };
        },

        methods: {
            fnSiList: function () {
                let self = this;

                $.ajax({
                    url: "http://localhost:8080/area/si.dox",
                    dataType: "json",
                    type: "POST",
                    data: {},
                    success: function (data) {
                        console.log(data);
                        self.siList = data.siList;
                    }
                });
            },

            fnGuList: function () {
                let self = this;

                self.gu = "";
                self.dong = "";
                self.guList = [];
                self.dongList = [];

                if (!self.si) {
                    return;
                }

                let param = {
                    si: self.si
                };

                $.ajax({
                    url: "http://localhost:8080/area/gu.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.guList = data.guList;
                    }
                });
            },

            fnDongList: function () {
                let self = this;

                self.dong = "";
                self.dongList = [];

                if (!self.gu) {
                    return;
                }

                let param = {
                    si: self.si,
                    gu: self.gu
                };

                $.ajax({
                    url: "http://localhost:8080/area/dong.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.dongList = data.dongList;
                    }
                });
            },
            fnGetWeather: function () {
                let self = this;

                let param = {
                    serviceKey : decodeURIComponent("b824f351a97d93326cfc5141b42fcbd3ffea0ea9d67e2c48748fe3ea0e4e1265"),
                    pageNo : 1,
                    numOfRows : 1000,
                    dataType : "JSON",
                    base_date : "20261113",
                    base_time : "0900",
                    nx : self.dong.nx,
                    ny : self.dong.ny
                };

                $.ajax({
                    url: "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst",
                    dataType: "json",
                    type: "GET",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        let items = data.response.body.items.item;
                        for(let i=0; i<items.length; i++){
                            let item = items[i];
                            if(item.category == 'T1H'){
                                // 기온에 대한 처리
                                console.log("기온 ==>  " + item.obsrValue);
                            }
                            if(item.category == 'RN1'){
                                // 한시간 강수량 mm
                                console.log("한시간 강수량  ==>  " + item.obsrValue);
                            }
                            if(item.category == 'PTY'){
                                // 강수량에 대한 처리
                                // 없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4), 빗방울(5), 빗방울눈날림(6), 눈날림(7) 
                                console.log("강수형태  ==>  " + item.obsrValue);
                            }
                        }
                    }
                });
            }
        },

        mounted() {
            let self = this;
            self.fnSiList();
            // self.fnGetWeather();
        }
    });

    app.mount('#app');
</script>

</body>
</html>
