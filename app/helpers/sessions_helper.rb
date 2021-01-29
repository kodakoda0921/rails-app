module SessionsHelper
  # userモデルにトークンの取得、ハッシュ化、記憶を行わせた後、クッキー情報を更新する
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_digest] = user.remember_token
  end

  # userモデルに、DB上にて記憶してあったダイジェスト情報を破棄させた後、クッキー情報を削除する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_digest)
  end
end
