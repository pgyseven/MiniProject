function startTimer() {
   let timer = 5;

   setInterval(() => {
    //conslole.log(--timer);

    if (timer >= 0 ) { 
        let min = Math.floor(timer / 60 ); //소주점을 자름 Math.floor
        let sec = String(timer % 60).padStart(2, '0'); // 2자리 만들어주고 빈자리는 0을 채운다 초에서 9초에서 09은 이걸로 채운거
        let remainTime = min + " : " + sec;
        $('.timer').html(remainTime);
        --timer;
    }else{
        $('#authBtn').prop('disabled', true);
        // $('#authBtn').css('background-color','#990000');
        
        // 백엔드에 인증시간이 만료되었음을 알려야 한다!
    }
    
   }, 1000); // 1000 milliseconds = 1 second
}