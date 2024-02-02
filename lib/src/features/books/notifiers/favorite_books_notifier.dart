import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../repositories/favorite_books_repository.dart';
import '../models/favorite_book.dart';
import '../states/favorite_books_state.dart';

class FavoriteBooksNotitier extends StateNotifier<FavoriteBooksState> {
  FavoriteBooksNotitier(this._ref, {required this.bookId})
      : super(FavoriteBooksState.initial()) {
    checkIsFavorite(bookId);
  }

  final Ref _ref;

  final String bookId;

  Future<void> checkIsFavorite(String bookId) async {
    final isFavorite = await _ref.read(favoriteBooksRepository).bookExists(bookId);
    state = state.copyWith(isFavorite: isFavorite);
  }

  Future<void> addOrRemoveFromFavorite(FavoriteBook book) async {
    if (state.isFavorite) {
      await removeBookFromFavorite(book);
    } else {
      await addBookToFavorite(book);
    }
  }

  Future<void> addBookToFavorite(FavoriteBook favoriteBook) async {
    await _ref.read(favoriteBooksRepository).addBookToFavorite(favoriteBook);

    await checkIsFavorite(favoriteBook.id);
  }

  Future<void> removeBookFromFavorite(FavoriteBook favoriteBook) async {
    await _ref.read(favoriteBooksRepository).removeBookFromFavorite(favoriteBook);

    await checkIsFavorite(favoriteBook.id);
  }
}

final favoriteBooksNotifierProvider = StateNotifierProvider.family<
    FavoriteBooksNotitier, FavoriteBooksState, String>(
  (ref, bookId) => FavoriteBooksNotitier(ref, bookId: bookId),
);
