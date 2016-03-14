# parti 빠띠 유쾌한 민주주의 플랫폼

## 로컬 개발 환경 구축 방법

기본적인 Rail 개발 환경에 rbenv를 이용합니다.

```
$ rbenv install 2.2.3
$ bundle install
$ bundle exec rake db:migrate
```

### 초기 데이터 추가

[mbleigh/seed-fu](https://github.com/mbleigh/seed-fu) 을 이용하여 설정된 초기 데이터를 로딩합니다.

```
$ bundle exec rake db:seed_fu
```

### 메일 확인

http://parti.dev/devel/emails 에서 메일 발송을 확인 할 수 있습니다.

### 포스트마커 연동

.powenv에 API키를 등록 합니다.

```
export POSTMARKER_API_KEY="키값"
```

### 아래를 rails console에서 수행하면 지워진 글의 댓글을 삭제합니다

Comment.all.each { |c| c.destroy if c.post.blank? }
