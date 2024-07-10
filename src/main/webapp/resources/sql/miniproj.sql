
use pgy;
-- 회원 테이블 생성
CREATE TABLE `pgy`.`member` (
  `userId` VARCHAR(8) NOT NULL,
  `userPwd` VARCHAR(200) NOT NULL,
  `userName` VARCHAR(12) NULL,
  `mobile` VARCHAR(13) NULL,
  `email` VARCHAR(50) NULL,
  `registerDate` DATETIME NULL DEFAULT now(),
  `userImg` VARCHAR(45) NOT NULL DEFAULT 'avatar.png',
  PRIMARY KEY (`userId`),
  UNIQUE INDEX `mobile_UNIQUE` (`mobile` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE);

-- 회원 테이블 수정(회원 포인트 점수 컬럼 부여)
ALTER TABLE `pgy`.`member` 
ADD COLUMN `userPoint` INT NULL DEFAULT 100 AFTER `userImg`;

-- DB 서버의 현재날짜와 현재 시간을 출력하는 쿼리문;
select now();

select md5('1234'); -- 암호화 기법 여러가지중 md5 쓴거임
select sha1('1234');

select sha1(md5('1234')); -- 실무에서는 이런식으로 두번 암호화 함

-- Member 테이블에 회원을 insert 하는 쿼리문
insert into member(userId, userPwd, userName, mobile, email) values(?, sha1(md5(?)), ?, ?, ?);

-- userId 로 해당 유저의 정보를 검색하는 쿼리문
select * from member where useId = ?;

-- member 테이블의 모든 회원 정보 검색하는 쿼리문
select * from member;

-- userId 가  ?인 회원 삭제 (회원 탈퇴)
delete from member where userId = ?;

-- dooly 라는 회원의 이메일을 수정하는 쿼리문
update member set email = 'dooly@dooly.com' where userId = 'dooly'; 
-- 데이터 선택 안되었다 에러드면 스키마 이름을 pgy.member 이렇게 use pgy; !

-- dooly 회원이 전화번호를 변결할 때 쿼리문 업데이트 쿼리문은 경우의 수가 많다 모바일일 수 도 있고 아닐수 도
update member set mobile = ? where userId = ?; 


-- 계층형 게시판 생성
CREATE TABLE `pgy`.`hboard` (
  `boardNo` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(20) NOT NULL,
  `content` VARCHAR(2000) NULL,
  `writer` VARCHAR(8) NULL,
  `postDate` DATETIME NULL DEFAULT now(),
  `readCount` INT NULL DEFAULT 0,
  `ref` INT NULL DEFAULT 0,
  `step` INT NULL DEFAULT 0,
  `refOrder` INT NULL DEFAULT 0,
  PRIMARY KEY (`boardNo`),
  INDEX `hboard_member_fk_idx` (`writer` ASC) VISIBLE,
  CONSTRAINT `hboard_member_fk`
    FOREIGN KEY (`writer`)
    REFERENCES `pgy`.`member` (`userId`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
COMMENT = '계층형 게시판';

-- 계층형 게시판에 모든 게시글을 가져오는 쿼리문
select * from hboard order by boardNo desc;

-- 계층형 게시판에 게시글을 등록하는 쿼리문
insert into hboard(title, content, writer)
values('아싸~~ 1등이다.', '내용 무....', 'dooly');

insert into hboard(title, content, writer)
values('금산에 살얼이', '죽고 죽어 일백번', 'kildong');

insert into hboard(title, content, writer)
values(?, ?, ?);