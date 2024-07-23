## A shared controller object for coordinating persistence read/writes
class_name PersistenceController
extends Resource

const FUNC_WRITER_NAME := &"_on_write"
const FUNC_READER_NAME := &"_on_restore"

const SAVE_NAME_TRANSIENT := &"Transient"

## This signal is called before a coordinate read is performed (Useful for cleanup)
signal will_load()

## Called when a coordinated start_save is requested.
## To actually start_save data, call the [PersistenceController::write] function.
## (Note: writers do not need to close the [file_ref] passed to them.)
signal save_requested(save_name: StringName)

## Called when a coordinated read is requested.
## To start_restore data, call the [PersistenceController::start_restore] function.
## (Note: readers do not need to close the [file_ref] passed to them.)
signal load_requested(save_name: StringName)


#region Save/Load

## Starts a coordinated write
func start_save(save_name: StringName) -> void:
    save_requested.emit(save_name)


## Starts a coordinated restore
func start_restore(save_name: StringName) -> void:
    will_load.emit()
    load_requested.emit(save_name)


## Saves state into a temporary save dir
func save_transient() -> void:
    save_requested.emit(SAVE_NAME_TRANSIENT)


## Restores state from the temporary save dir
func restore_transient() -> void:
    load_requested.emit(SAVE_NAME_TRANSIENT)


## Writes a data file into the specified start_save dir.
## This method expects the [writer] object to have a function with the signature: [_on_write(file: FileAccess)])
static func write(writer: Object,
        save_name: StringName,
        data_id: StringName) -> void:

    # Validation #
    assert(writer.has_method(FUNC_WRITER_NAME))
    make_save_dir_if_needed(save_name)

    var data_path := get_data_path_for(save_name, data_id)
    var file := FileAccess.open(data_path, FileAccess.WRITE)

    if file == null:
        return

    # Operation #
    writer.call(FUNC_WRITER_NAME, file)
    file.close()


## Restores state using a data file from the specified start_save dir.
## This method expects the [reader] object to have a function with the signature: [_on_restore(file: FileAccess)])
static func restore(reader: Object,
        save_name: StringName,
        data_id: StringName) -> void:

    # Validation #
    assert(reader.has_method(FUNC_READER_NAME))

    var data_path := get_data_path_for(save_name, data_id)

    if !FileAccess.file_exists(data_path):
        return

    var file := FileAccess.open(data_path, FileAccess.READ)

    if file == null:
        return

    # Operation #
    reader.call(FUNC_READER_NAME, file)
    file.close()


#endregion

#region Utils

## Returns the path to a specified start_save dir
static func get_save_path_for(save_name: StringName) -> String:
    if save_name.is_empty():
        return ""

    return "user://Saves/%s/" % save_name


## Returns the path to a specified data file
static func get_data_path_for(save_name: StringName, data_id: StringName) -> String:
    if save_name.is_empty() || data_id.is_empty():
        return ""

    return "user://Saves/%s/%s" % [save_name, data_id]


## Returns true if a specified start_save data exists
static func save_exists(save_name: StringName) -> bool:
    return DirAccess.dir_exists_absolute(get_save_path_for(save_name))


## Creates a start_save data dir if it doesn't exist
static func make_save_dir_if_needed(save_name: StringName) -> void:
    var save_path := get_save_path_for(save_name)

    if save_path.is_empty():
        return

    if DirAccess.dir_exists_absolute(save_path):
        return

    DirAccess.make_dir_recursive_absolute(save_path)


## Deletes a specified start_save data dir
static func delete_save_dir(save_name: StringName) -> void:
    var save_path := get_save_path_for(save_name)

    # Imagine not having a recursive delete function
    # in a supposed-to-be 'high-level' API /hj
    var save_dir := DirAccess.open(save_path)

    if save_dir == null:
        return

    for filename: String in save_dir.get_files():
        save_dir.remove(filename)

    DirAccess.remove_absolute(save_path)


## Transfers data from one start_save data to another
## (If [move_mode] is set to true, the source data dir will be deleted.)
static func copy_save_data(source_name: StringName,
                        destination_name: StringName,
                        move_mode: bool = false) -> void:

    # Validation #
    var source_path := get_save_path_for(source_name)
    var destination_path := get_save_path_for(destination_name)

    if (source_path.is_empty() ||
        destination_path.is_empty() ||
        !DirAccess.dir_exists_absolute(source_path)):
        return

    make_save_dir_if_needed(destination_name)

    # Operation #
    var source_files := DirAccess.get_files_at(source_path)

    for filename: String in source_files:
        var file_src_path := get_data_path_for(source_name, filename)
        var file_dst_path := get_data_path_for(destination_name, filename)

        DirAccess.copy_absolute(file_src_path, file_dst_path)

    if !move_mode:
        return

    delete_save_dir(source_name)


## Returns a list of save names
static func get_save_names() -> PackedStringArray:
    return DirAccess.get_directories_at("user://Saves")


## Returns a list of data ID filenames in the specified save file
static func get_data_ids(save_name: StringName) -> PackedStringArray:
    var save_path := get_save_path_for(save_name)

    if !DirAccess.dir_exists_absolute(save_path):
        return PackedStringArray()

    return DirAccess.get_files_at(save_path)

#endregion

#region Shorthands

## Returns true if transient data exists in the saves dir
static func has_transient_data() -> bool:
    return save_exists(SAVE_NAME_TRANSIENT)


## Removes transient data
static func delete_transient_data() -> void:
    delete_save_dir(SAVE_NAME_TRANSIENT)

#endregion